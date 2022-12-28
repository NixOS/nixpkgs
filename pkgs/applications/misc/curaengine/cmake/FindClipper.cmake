# Find Clipper library (http://www.angusj.com/delphi/clipper.php).
# The following variables are set
#
# CLIPPER_FOUND
# CLIPPER_INCLUDE_DIRS
# CLIPPER_LIBRARIES
#
# It searches the environment variable $CLIPPER_PATH automatically.

unset(CLIPPER_FOUND CACHE)
unset(CLIPPER_INCLUDE_DIRS CACHE)
unset(CLIPPER_LIBRARIES CACHE)
unset(CLIPPER_LIBRARIES_RELEASE CACHE)
unset(CLIPPER_LIBRARIES_DEBUG CACHE)

if(CMAKE_BUILD_TYPE MATCHES "(Debug|DEBUG|debug)")
    set(CLIPPER_BUILD_TYPE DEBUG)
else()
    set(CLIPPER_BUILD_TYPE RELEASE)
endif()

FIND_PATH(CLIPPER_INCLUDE_DIRS clipper.hpp
    PATH_SUFFIXES polyclipping 
    PATHS include/polyclipping ENV CLIPPER_PATH
    )

set(_deb_postfix "d")

FIND_LIBRARY(CLIPPER_LIBRARIES_RELEASE polyclipping)
FIND_LIBRARY(CLIPPER_LIBRARIES_DEBUG polyclipping${_deb_postfix})

if(CLIPPER_LIBRARIES_${CLIPPER_BUILD_TYPE})
    set(CLIPPER_LIBRARIES "${CLIPPER_LIBRARIES_${CLIPPER_BUILD_TYPE}}")
else()
    set(CLIPPER_LIBRARIES "${CLIPPER_LIBRARIES_RELEASE}")
endif()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Clipper
    "Clipper library cannot be found.  Consider set CLIPPER_PATH environment variable"
    CLIPPER_INCLUDE_DIRS
    CLIPPER_LIBRARIES)

MARK_AS_ADVANCED(
    CLIPPER_INCLUDE_DIRS
    CLIPPER_LIBRARIES)

if(CLIPPER_FOUND)
    add_library(Clipper::Clipper UNKNOWN IMPORTED)
    set_target_properties(Clipper::Clipper PROPERTIES IMPORTED_LOCATION ${CLIPPER_LIBRARIES})
    set_target_properties(Clipper::Clipper PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CLIPPER_INCLUDE_DIRS})
    if(CLIPPER_LIBRARIES_RELEASE AND CLIPPER_LIBRARIES_DEBUG)
        set_target_properties(Clipper::Clipper PROPERTIES
            IMPORTED_LOCATION_DEBUG          ${CLIPPER_LIBRARIES_DEBUG}
            IMPORTED_LOCATION_RELWITHDEBINFO ${CLIPPER_LIBRARIES_RELEASE}
            IMPORTED_LOCATION_RELEASE        ${CLIPPER_LIBRARIES_RELEASE}
            IMPORTED_LOCATION_MINSIZEREL     ${CLIPPER_LIBRARIES_RELEASE}
        )
    endif()
endif()
