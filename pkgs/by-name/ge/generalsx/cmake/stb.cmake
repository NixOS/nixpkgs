# nixpkgs: use packaged stb headers instead of fetching the source with CMake.
find_package(PkgConfig REQUIRED)
pkg_check_modules(STB REQUIRED IMPORTED_TARGET stb)

add_library(stb INTERFACE)
target_link_libraries(stb INTERFACE PkgConfig::STB)
