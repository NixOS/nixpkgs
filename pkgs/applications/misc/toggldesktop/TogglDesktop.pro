QT += core network widgets

DEFINES += APP_ENVIRONMENT=\\\"production\\\"
DEFINES += APP_VERSION=\\\"@version@\\\"

TARGET = toggldesktop
TEMPLATE = app

SOURCES += *.cpp
HEADERS += *.h
FORMS += *.ui
RESOURCES += *.qrc

target.path = $$PREFIX

INSTALLS += target

CONFIG += link_pkgconfig
PKGCONFIG += bugsnag-qt qxtglobalshortcut qt-oauth-lib toggl x11 xscrnsaver
