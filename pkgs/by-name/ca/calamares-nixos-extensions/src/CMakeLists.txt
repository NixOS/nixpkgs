# === This file is part of Calamares - <https://github.com/calamares> ===
#
#   Calamares is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Calamares is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
#
#   SPDX-License-Identifier: GPL-3.0+
#   License-Filename: LICENSE
#
###
#
# This is an example of a repository containing Calamares branding-components
# and Calamares modules and Calamares configuration, showing how a single
# repository can be used to provide customisation for Calamares, so that a
# distro can use an unmodified (upstream) Calamares package and a local
# customisation package in tandem.
#
cmake_minimum_required(VERSION 3.3 FATAL_ERROR)
project(calamares-extensions
    VERSION 1.1.1
    LANGUAGES CXX
)

find_package(Calamares 3.2.26 REQUIRED)

find_package(YAMLCPP REQUIRED)  # Needed to untangle some dependencies before Calamares 3.2.36

### CMAKE SETUP
#
# Enable IN_LIST
if( POLICY CMP0057 )
    cmake_policy( SET CMP0057 NEW )
endif()
# Let ``AUTOMOC`` and ``AUTOUIC`` process ``GENERATED`` files.
if( POLICY CMP0071 )
    cmake_policy( SET CMP0071 NEW )
endif()
# Recognize more macros to trigger automoc
if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.10.0")
    list(APPEND CMAKE_AUTOMOC_MACRO_NAMES
        "K_PLUGIN_FACTORY_WITH_JSON"
        "K_EXPORT_PLASMA_DATAENGINE_WITH_JSON"
        "K_EXPORT_PLASMA_RUNNER"
    )
endif()


### BRANDING
#
# Typically you would use only one branding, since that's
# the (single) branding for your distro.
#
calamares_add_branding_subdirectory( branding/default NAME default )
calamares_add_branding_subdirectory( branding/default-mobile NAME default-mobile )
calamares_add_branding_subdirectory( branding/fancy NAME fancy )

# This one has files in subdirectories
calamares_add_branding_subdirectory( branding/samegame NAME samegame SUBDIRECTORIES img )

# KaOS branding, with translations, note we can *NAME* something
# different from the source directory it lives in; this will be installed
# to a directory called *NAME* though -- and the `branding.desc` must
# have a *componentName* that matches this *NAME*.
calamares_add_branding_subdirectory( branding/kaos_branding NAME kaos )

### MODULES
#
# Add one of more modules, either C++ or Python.
#
set(SKIPPED_MODULES "")

calamares_add_module_subdirectory( modules/filekeeper )  # C++ job
calamares_add_module_subdirectory( modules/freebsddisk )  # C++ viewmodule
calamares_add_module_subdirectory( modules/mobile )
calamares_add_module_subdirectory( modules/slowpython )  # Python job

# If modules cannot be built, they usually call a macro
# which builds a list of explanations; show that list.
calamares_explain_skipped_modules( ${SKIPPED_MODULES} )

### RELEASE SUPPORT
#
#
set( CALAMARES_VERSION ${calamares-extensions_VERSION_MAJOR}.${calamares-extensions_VERSION_MINOR}.${calamares-extensions_VERSION_PATCH} )
# In rare cases we have hotfix-releases with a tweak
if( calamares-extensions_VERSION_TWEAK )
    set( CALAMARES_VERSION "${calamares-extensions_VERSION}.${calamares-extensions_VERSION_TWEAK}" )
endif()
set( CALAMARES_VERSION_SHORT "${CALAMARES_VERSION}" )

add_custom_target(show-version
    ${CMAKE_COMMAND} -E echo CALAMARES_VERSION=${CALAMARES_VERSION_SHORT}
    USES_TERMINAL
)
