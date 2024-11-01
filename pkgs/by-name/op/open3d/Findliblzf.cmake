cmake_policy(PUSH)
find_library(
  LIBLZF_LIBRARY
  NAMES lzf
  PATH_SUFFIXES lib)
find_path(LIBLZF_INCLUDE_DIR lzf.h PATH_SUFFIXES include)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(liblzf REQUIRED_VARS LIBLZF_LIBRARY
                                                       LIBLZF_INCLUDE_DIR)
if(liblzf_FOUND)
  if(NOT TARGET liblzf::liblzf)
    add_library(liblzf::liblzf INTERFACE IMPORTED)
    target_link_libraries(liblzf::liblzf INTERFACE "${LIBLZF_LIBRARY}")
    target_include_directories(liblzf::liblzf SYSTEM
                               INTERFACE "${LIBLZF_INCLUDE_DIR}")
  endif()
endif()
cmake_policy(POP)
