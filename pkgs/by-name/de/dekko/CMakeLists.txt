project(QuickFlux)

cmake_minimum_required(VERSION 3.0)
set(CMAKE_GENERATOR "Unix Makefiles")

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_AUTOMOC True)

if (CMAKE_BUILD_TYPE MATCHES Debug)
    set(CMAKE_CXX_FLAGS "-O0 -g -Wall -Wsign-compare ${CMAKE_CXX_FLAGS}")
else()
    set(CMAKE_CXX_FLAGS "-O2 -Wall -Wsign-compare ${CMAKE_CXX_FLAGS} -s")
endif()

message(STATUS "CXXFLAGS ARE ${CMAKE_CXX_FLAGS}")

include(GNUInstallDirs)

if(DEFINED QT_IMPORTS_DIR)
    message(STATUS "Qt import dir already set, install QuickFlux to ${QT_IMPORTS_DIR}")
else()
    if(EXISTS "/etc/debian_version")
        set(QT_IMPORTS_DIR ${CMAKE_INSTALL_LIBDIR}/qt5/qml)
    else()
        set(QT_IMPORTS_DIR ${CMAKE_INSTALL_LIBDIR}/${CMAKE_LIBRARY_ARCHITECTURE}/qt5/qml)
    endif()
endif()

find_package(Qt5Core REQUIRED)
find_package(Qt5Quick REQUIRED)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/quickflux/src
    ${CMAKE_CURRENT_SOURCE_DIR}/quickflux/src/priv
    ${CMAKE_CURRENT_BINARY_DIR}/quickflux/src
    ${CMAKE_CURRENT_BINARY_DIR}/quickflux/src/priv
)

set(QUICKFLUX_DIR ${CMAKE_CURRENT_SOURCE_DIR}/quickflux)
set(QuickFlux_SRCS
    ${CMAKE_CURRENT_SOURCE_DIR}/quickflux_plugin.cpp
    ${QUICKFLUX_DIR}/src/qfapplistener.cpp
    ${QUICKFLUX_DIR}/src/qfappdispatcher.cpp
    ${QUICKFLUX_DIR}/src/qfappscript.cpp
    ${QUICKFLUX_DIR}/src/qfappscriptrunnable.cpp
    ${QUICKFLUX_DIR}/src/priv/qfappscriptrunnable.h
    ${QUICKFLUX_DIR}/src/qfappscriptdispatcherwrapper.cpp
    ${QUICKFLUX_DIR}/src/priv/qfappscriptdispatcherwrapper.h
    ${QUICKFLUX_DIR}/src/qflistener.cpp
    ${QUICKFLUX_DIR}/src/priv/qflistener.h
    ${QUICKFLUX_DIR}/src/qfapplistenergroup.cpp
    ${QUICKFLUX_DIR}/src/qfappscriptgroup.cpp
    ${QUICKFLUX_DIR}/src/qffilter.cpp
    ${QUICKFLUX_DIR}/src/qfkeytable.cpp
    ${QUICKFLUX_DIR}/src/priv/qfsignalproxy.cpp
    ${QUICKFLUX_DIR}/src/qfactioncreator.cpp
    ${QUICKFLUX_DIR}/src/qfdispatcher.cpp
    ${QUICKFLUX_DIR}/src/qfqmltypes.cpp
    ${QUICKFLUX_DIR}/src/qfhydrate.cpp
    ${QUICKFLUX_DIR}/src/qfmiddleware.cpp
    ${QUICKFLUX_DIR}/src/priv/qfmiddlewareshook.cpp
    ${QUICKFLUX_DIR}/src/priv/quickfluxfunctions.cpp
    ${QUICKFLUX_DIR}/src/priv/qfhook.cpp
    ${QUICKFLUX_DIR}/src/qfmiddlewarelist.cpp
    ${QUICKFLUX_DIR}/src/qfstore.cpp
    ${QUICKFLUX_DIR}/src/qfobject.cpp
)

add_library(quickflux SHARED ${QuickFlux_SRCS})

target_compile_definitions(quickflux
  PRIVATE
  QUICK_FLUX_DISABLE_AUTO_QML_REGISTER
)

qt5_use_modules(quickflux Core Quick)

set(QUICKFLUX_PLUGIN_DIR ${QT_IMPORTS_DIR}/QuickFlux)


install(TARGETS quickflux DESTINATION ${QUICKFLUX_PLUGIN_DIR})
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/qmldir DESTINATION ${QUICKFLUX_PLUGIN_DIR})
