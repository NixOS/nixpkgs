##  Finds the Stb utility library on your computer.
#
#   This script exports the following parameters for use if you find the Stb
#   package:
#   - Stb_FOUND: Whether Stb has been found on your computer.
#   - Stb_INCLUDE_DIRS: The directory where the header files of Stb are located.

find_package(PkgConfig QUIET)
pkg_check_modules(PC_Stb QUIET Stb)

find_path(Stb_INCLUDE_DIRS stb_image_resize.h #Search for something that is a little less prone to false positives than just stb.h.
    HINTS ${PC_Stb_INCLUDEDIR} ${PC_Stb_INCLUDE_DIRS}
    PATHS "$ENV{PROGRAMFILES}" "$ENV{PROGRAMW6432}" "/usr/include"
    PATH_SUFFIXES include/stb stb include
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Stb DEFAULT_MSG Stb_INCLUDE_DIRS)

mark_as_advanced(Stb_INCLUDE_DIRS)

if(Stb_FOUND)
    message(STATUS "Found Stb installation at: ${Stb_INCLUDE_DIRS}")
    add_library(Stb::Stb INTERFACE IMPORTED)
    set_target_properties(Stb::Stb PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${Stb_INCLUDE_DIRS})
endif()
