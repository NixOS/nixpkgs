cmake_minimum_required (VERSION 3.19)

project (wfs-tools)

add_subdirectory(wfslib)

add_subdirectory(wfs-extract)
add_subdirectory(wfs-file-injector)
#add_subdirectory(wfs-fuse)