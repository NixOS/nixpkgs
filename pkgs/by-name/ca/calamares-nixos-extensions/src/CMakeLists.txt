project(calamares-branding LANGUAGES NONE)
cmake_minimum_required(VERSION 3.2)

find_package(Calamares REQUIRED)
include( "${CALAMARES_USE_FILE}" )

calamares_add_branding_subdirectory( default )
calamares_add_branding_subdirectory( fancy )

# This one has files in subdirectories
calamares_add_branding_subdirectory( samegame SUBDIRECTORIES img )

# KaOS branding, with translations
calamares_add_branding_subdirectory( kaos_branding )
