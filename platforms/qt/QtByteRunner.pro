#-------------------------------------------------
#
# Project created by QtCreator 2011-01-14T12:35:23
#
#-------------------------------------------------

QT       += core
QMAKE_TARGET_BUNDLE_PREFIX = dk.area9

CONFIG(no_gui) {
} else {
    CONFIG += use_gui
}

# Uncomment to enable Flow Cpp native build (without bytecode)
#CONFIG += native_build

win32:contains(QMAKE_TARGET.arch, x86_64) {
    CONFIG += use_jit
}

unix:contains(QMAKE_HOST.arch,x86_64) {
    CONFIG += use_jit
}

DEFINES += FLOW_COMPACT_STRUCTS

CONFIG(use_gui) {
    QT += gui opengl multimedia multimediawidgets

    CONFIG += c++11

    QT += opengl
    QT += widgets gui
    QT += webenginewidgets webchannel

    #QMAKE_CXXFLAGS_DEBUG   += -std=c++11
    #QMAKE_CXXFLAGS_RELEASE += -std=c++11

    macx {
        # -O2 is too crashy on Mac; see #34057 - ST 12/17/14, 3/30/15
        INCLUDEPATH += /usr/local/include
        QMAKE_CFLAGS_RELEASE -= -O2
        QMAKE_CXXFLAGS_RELEASE -= -O2
        LIBS += -framework GLUT
        LIBS += -L$$PWD/libs
    }

    win32 {
        INCLUDEPATH += win32-libs/include

        contains(QMAKE_TARGET.arch, x86_64) {
            LIBS += -L$$PWD/win32-libs/lib64
        } else {
            LIBS += -L$$PWD/win32-libs/lib
        }

        LIBS += -lglew32 -lopengl32 -lglu32
    }

    unix:!macx {
        LIBS += -lGLU
    }

    LIBS += -lz -ljpeg -lpng
} else {
    QT -= gui opengl
}

QT += sql
QT += network
QT += websockets

TARGET = QtByteRunner
TEMPLATE = app

PRECOMPILED_HEADER = pcheader.h

INCLUDEPATH += ../common/cpp ../common/cpp/include qt-gui qt-backend ../common/cpp/asmjit/src

CONFIG          += console

#QMAKE_CXXFLAGS_DEBUG += -fpermissive
#QMAKE_CXXFLAGS_RELEASE += -fpermissive

#QMAKE_CXXFLAGS_DEBUG += -pg
#QMAKE_LFLAGS_DEBUG += -pg

isEmpty(TARGET_EXT) {
    win32 {
        TARGET_CUSTOM_EXT = .exe
    }
    macx {
        TARGET_CUSTOM_EXT = .app
    }
} else {
    TARGET_CUSTOM_EXT = $${TARGET_EXT}
}

CONFIG(debug, debug|release) {
    DEFINES += DEBUG_FLOW
    DEPLOY_DIR = $$shell_quote($$shell_path($${OUT_PWD}/debug))
    DEPLOY_TARGET = $$shell_quote($$shell_path($${OUT_PWD}/debug/$${TARGET}$${TARGET_CUSTOM_EXT}))
} else {
    DEFINES += NDEBUG
    DEPLOY_DIR = $$shell_quote($$shell_path($${OUT_PWD}/release))
    DEPLOY_TARGET = $$shell_quote($$shell_path($${OUT_PWD}/release/$${TARGET}$${TARGET_CUSTOM_EXT}))
}

win32 {
    QMAKE_POST_LINK = windeployqt $${DEPLOY_TARGET}

    contains(QMAKE_TARGET.arch, x86_64) {
        QMAKE_POST_LINK += & copy $$shell_quote($$shell_path($${PWD}/win32-libs/bin64/*)) $${DEPLOY_DIR};
    } else {
        QMAKE_POST_LINK += & copy $$shell_quote($$shell_path($${PWD}/win32-libs/bin/*)) $${DEPLOY_DIR};
    }
}

macx {
    QMAKE_POST_LINK = macdeployqt $$shell_quote($$shell_path($${OUT_PWD}/$${TARGET}$${TARGET_CUSTOM_EXT}))
}

# Core

SOURCES += \
    ../common/cpp/core/ByteCodeRunner.cpp \
    ../common/cpp/core/ByteMemory.cpp \
    ../common/cpp/core/CodeMemory.cpp \
    ../common/cpp/core/MemoryArea.cpp \
    ../common/cpp/core/GarbageCollector.cpp \
    ../common/cpp/core/HeapWalker.cpp \
    ../common/cpp/core/Natives.cpp \
    ../common/cpp/core/Utf8.cpp \
    ../common/cpp/core/Utf32.cpp \
    ../common/cpp/core/md5.cpp \
    ../common/cpp/utils/AbstractHttpSupport.cpp \
    ../common/cpp/utils/AbstractSoundSupport.cpp \
    ../common/cpp/utils/FileLocalStore.cpp \
    ../common/cpp/utils/FileSystemInterface.cpp \
    ../common/cpp/utils/AbstractNotificationsSupport.cpp \
    ../common/cpp/utils/AbstractGeolocationSupport.cpp \
    ../common/cpp/utils/flowfilestruct.cpp \
    ../common/cpp/utils/AbstractWebSocketSupport.cpp \
    qt-backend/NotificationsSupport.cpp \
    qt-backend/QtGeolocationSupport.cpp \
    qt-backend/qfilesysteminterface.cpp \
    qt-backend/RunParallel.cpp \
    qt-backend/QWebSocketSupport.cpp \
    qt-gui/VideoWidget.cpp \
    qt-gui/mainwindow.cpp

HEADERS  += \
    pcheader.h \
    ../common/cpp/core/ByteCodeRunner.h \
    ../common/cpp/core/CommonTypes.h \
    ../common/cpp/core/nativefunction.h \
    ../common/cpp/core/ByteMemory.h \
    ../common/cpp/core/CodeMemory.h \
    ../common/cpp/core/MemoryArea.h \
    ../common/cpp/core/GarbageCollector.h \
    ../common/cpp/core/HeapWalker.h \
    ../common/cpp/core/opcodes.h \
    ../common/cpp/core/RunnerMacros.h \
    ../common/cpp/core/STLHelpers.h \
    ../common/cpp/core/md5.h \
    ../common/cpp/utils/AbstractHttpSupport.h \
    ../common/cpp/utils/AbstractSoundSupport.h \
    ../common/cpp/utils/FileLocalStore.h \
    ../common/cpp/core/NativeProgram.h \
    ../common/cpp/utils/FileSystemInterface.h \
    ../common/cpp/utils/AbstractNotificationsSupport.h \
    ../common/cpp/utils/AbstractGeolocationSupport.h \
    ../common/cpp/utils/flowfilestruct.h \
    ../common/cpp/utils/AbstractWebSocketSupport.h \
    qt-backend/NotificationsSupport.h \
    qt-backend/QtGeolocationSupport.h \
    qt-backend/qfilesysteminterface.h \
    qt-backend/RunParallel.h \
    qt-backend/QWebSocketSupport.h \
    qt-gui/VideoWidget.h \
    qt-gui/testopengl.h \
    qt-gui/mainwindow.h

# Asmjit

CONFIG(use_jit) {
	DEFINES += FLOW_JIT
	DEFINES += ASMJIT_STATIC
	DEFINES += ASMJIT_DISABLE_COMPILER

        SOURCES += ../common/cpp/core/JitProgram.cpp
        HEADERS += ../common/cpp/core/JitProgram.h

        SOURCES += $$files(../common/cpp/asmjit/src/asmjit/base/*.cpp) $$files(../common/cpp/asmjit/src/asmjit/x86/*.cpp)
        HEADERS += $$files(../common/cpp/asmjit/src/asmjit/*.h) $$files(../common/cpp/asmjit/src/asmjit/base/*.h) $$files(../common/cpp/asmjit/src/asmjit/x86/*.h)
}

# Non-gui

SOURCES += main.cpp\
    debugger.cpp \
    qt-backend/DatabaseSupport.cpp \
    qt-backend/HttpSupport.cpp \
    qt-backend/QtTimerSupport.cpp \
    qt-backend/CgiSupport.cpp \
    qt-backend/StartProcess.cpp

HEADERS  += \
    debugger.h \
    qt-backend/HttpSupport.h \
    qt-backend/DatabaseSupport.h \
    qt-backend/QtTimerSupport.h \
    qt-backend/CgiSupport.h \
    qt-backend/StartProcess.h

# Native program

CONFIG(native_build) {
    DEFINES += NATIVE_BUILD

    SOURCES += $$files(flowgen/*.cpp)
    HEADERS += $$files(flowgen/*.h)
} else {
    SOURCES += native_program_stub.cpp
}

# Gui

CONFIG(use_gui) {
    SOURCES += \
        swfloader.cpp \
        qt-gui/beveleffect.cpp \
        qt-gui/QGraphicsItemWrapper.cpp \
        qt-gui/soundsupport.cpp \
        qt-gui/QGLRenderSupport.cpp \
        qt-backend/QGLTextEdit.cpp \
        qt-backend/QGLLineEdit.cpp \
        qt-gui/QGLWebPage.cpp \
        qt-gui/QGLClipTreeModel.cpp \
        qt-gui/QGLClipTreeBrowser.cpp \
        ../common/cpp/gl-gui/GLRenderSupport.cpp \
        ../common/cpp/gl-gui/GLRenderer.cpp \
        ../common/cpp/gl-gui/GLUtils.cpp \
        ../common/cpp/gl-gui/GLClip.cpp \
        ../common/cpp/gl-gui/GLGraphics.cpp \
        ../common/cpp/gl-gui/GLPictureClip.cpp \
        ../common/cpp/gl-gui/GLVideoClip.cpp \
        ../common/cpp/gl-gui/GLTextClip.cpp \
        ../common/cpp/gl-gui/GLWebClip.cpp \
        ../common/cpp/gl-gui/GLFont.cpp \
        ../common/cpp/gl-gui/GLFilter.cpp \
        ../common/cpp/gl-gui/GLSchedule.cpp \
        ../common/cpp/gl-gui/GLCamera.cpp \
        ../common/cpp/gl-gui/ImageLoader.cpp \
        ../common/cpp/font/TextFont.cpp

    HEADERS  += \
        swfloader.h \
        qt-gui/beveleffect.h \
        qt-gui/GradientMatrix.h \
        qt-gui/soundsupport.h \
        qt-gui/QGLRenderSupport.h \
        qt-gui/QGraphicsItemWrapper.h \
        qt-backend/QGLTextEdit.h \
        qt-backend/QGLLineEdit.h \
        qt-gui/QGLWebPage.h  \
        qt-gui/QGLClipTreeModel.h \
        qt-gui/QGLClipTreeBrowser.h \
        ../common/cpp/gl-gui/GLRenderSupport.h \
        ../common/cpp/gl-gui/shaders/code.inc \
        ../common/cpp/gl-gui/GLRenderer.h \
        ../common/cpp/gl-gui/GLUtils.h \
        ../common/cpp/gl-gui/GLClip.h \
        ../common/cpp/gl-gui/GLGraphics.h \
        ../common/cpp/gl-gui/GLPictureClip.h \
        ../common/cpp/gl-gui/GLVideoClip.h \
        ../common/cpp/gl-gui/GLTextClip.h \
        ../common/cpp/gl-gui/GLWebClip.h \
        ../common/cpp/gl-gui/GLFont.h \
        ../common/cpp/gl-gui/GLFilter.h \
        ../common/cpp/gl-gui/GLSchedule.h \
        ../common/cpp/gl-gui/GLCamera.h \
        ../common/cpp/gl-gui/ImageLoader.h \
        ../common/cpp/font/Headers.h \
        ../common/cpp/font/TextFont.h

    RESOURCES += \
        QtByteRunnerRes.qrc

#    CONFIG(debug, debug|release) {
#        HEADERS += \
#            qt-gui/FlowClipTreeModel.h
#        SOURCES += \
#            qt-gui/FlowClipTreeModel.cpp
#    }
}

OTHER_FILES += \
    QtByteRunner.pro.user \
    readme.txt
