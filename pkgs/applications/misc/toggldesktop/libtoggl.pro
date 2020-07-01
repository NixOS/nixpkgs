TARGET = toggl
TEMPLATE = lib

SOURCES += *.cc
HEADERS += *.h

headers.files = $$HEADERS
headers.path = $$PREFIX/include
target.path = $$PREFIX/lib

INSTALLS += headers target

CONFIG += create_prl create_pc link_pkgconfig
PKGCONFIG += jsoncpp openssl lua poco sqlite3 x11

QMAKE_PKGCONFIG_NAME = $$TARGET
QMAKE_PKGCONFIG_PREFIX = $$PREFIX
QMAKE_PKGCONFIG_LIBDIR = $$target.path
QMAKE_PKGCONFIG_INCDIR = $$headers.path
QMAKE_PKGCONFIG_DESTDIR = pkgconfig
