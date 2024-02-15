cmake_minimum_required(VERSION 3.18)

project(wfs-tools)

add_subdirectory(wfslib)

add_subdirectory(wfs-extract)
add_subdirectory(wfs-file-injector)
add_subdirectory(wfs-info)
add_subdirectory(wfs-reencryptor)
if(NOT WIN32)
    add_subdirectory(wfs-fuse)
endif()
