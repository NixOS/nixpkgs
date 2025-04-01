find_path(CRYPTOPP_INCLUDE_DIR cryptopp/config.h
    HINTS ${ENV{CRYPTOPP_ROOT}}
    PATHS /usr/include /usr/local/include
    PATH_SUFFIXES include
)

find_library(CRYPTOPP_LIBRARY
    NAMES cryptopp
    HINTS ${ENV{CRYPTOPP_ROOT}}
    PATHS /usr/lib /usr/local/lib
    PATH_SUFFIXES lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cryptopp DEFAULT_MSG
    CRYPTOPP_LIBRARY
    CRYPTOPP_INCLUDE_DIR
)

if(Cryptopp_FOUND)
    set(CRYPTOPP_LIBRARIES ${CRYPTOPP_LIBRARY})
    set(CRYPTOPP_INCLUDE_DIRS ${CRYPTOPP_INCLUDE_DIR})
endif()

mark_as_advanced(CRYPTOPP_INCLUDE_DIR CRYPTOPP_LIBRARY)
