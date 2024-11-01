cmake_policy(PUSH)

find_library(
  FILAMENT_LIBRARY
  NAMES filament
  HINTS ${filament_DIR}
  PATH_SUFFIXES lib lib/x86_64)

find_library(
  FILAMENT_GEOMETRY_LIBRARY
  NAMES geometry
  HINTS ${filament_DIR}
  PATH_SUFFIXES lib lib/x86_64)

find_library(
  FILAMENT_IMAGE_LIBRARY
  NAMES image
  HINTS ${filament_DIR}
  PATH_SUFFIXES lib lib/x86_64)

find_path(
  FILAMENT_INCLUDE_DIR FilamentAPI.h
  HINTS ${filament_DIR}
  PATH_SUFFIXES include/filament)
find_path(
  FILAMENT_GEOMETRY_INCLUDE_DIR TangentSpaceMesh.h
  HINTS ${filament_DIR}
  PATH_SUFFIXES include/geometry)
find_path(
  FILAMENT_IMAGE_INCLUDE_DIR Ktx1Bundle.h
  HINTS ${filament_DIR}
  PATH_SUFFIXES include/image)

find_program(
  FILAMENT_MATC
  NAMES matc
  HINTS ${filament_DIR}
  PATH_SUFFIXES bin)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  filament
  REQUIRED_VARS FILAMENT_LIBRARY FILAMENT_GEOMETRY_LIBRARY
                FILAMENT_IMAGE_LIBRARY FILAMENT_MATC FILAMENT_INCLUDE_DIR)
if(filament_FOUND)
  if(NOT TARGET filament::filament)
    add_library(filament::filament INTERFACE IMPORTED)
    target_link_libraries(filament::filament INTERFACE "${FILAMENT_LIBRARY}")
    target_include_directories(filament::filament SYSTEM
                               INTERFACE "${FILAMENT_INCLUDE_DIR}")
  endif()
  if(NOT TARGET filament::geometry)
    add_library(filament::geometry INTERFACE IMPORTED)
    target_link_libraries(filament::geometry
                          INTERFACE "${FILAMENT_GEOMETRY_LIBRARY}")
    target_include_directories(filament::geometry SYSTEM
                               INTERFACE "${FILAMENT_GEOMETRY_INCLUDE_DIR}")
  endif()
  if(NOT TARGET filament::image)
    add_library(filament::image INTERFACE IMPORTED)
    target_link_libraries(filament::image INTERFACE "${FILAMENT_IMAGE_LIBRARY}")
    target_include_directories(filament::image SYSTEM
                               INTERFACE "${FILAMENT_IMAGE_INCLUDE_DIR}")
  endif()
endif()

cmake_policy(POP)
