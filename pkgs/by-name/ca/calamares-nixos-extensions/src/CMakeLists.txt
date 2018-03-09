project(calamares-branding LANGUAGES NONE)
cmake_minimum_required(VERSION 3.2)

find_package(Calamares REQUIRED)
include( "${CALAMARES_USE_FILE}" )

calamares_add_branding_subdirectory( default )
calamares_add_branding_subdirectory( fancy )
calamares_add_branding_subdirectory( samegame )

