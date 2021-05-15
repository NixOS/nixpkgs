# === This file is part of Calamares - <https://calamares.io> ===
#
#   SPDX-FileCopyrightText: 2014 Teo Mrnjavac <teo@kde.org>
#   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
#   SPDX-License-Identifier: BSD-2-Clause
#
###
#
# This file defines one function for extending a VERSION-like value
# with date and git information (if desired).
#
# - extend_version( version-string short_var long_var )
#   Calling this function will copy *version-string* (which would typically
#   be a semver-style string, like "3.2.40") into the variable *short_var*.
#   The *version-string* plus date and git information (if git is available),
#   is copied into the varialbe *long_var*, in the format {version}-{date}-{hash}
#
# A helper function that may be used independently:
#
# - get_git_version_info( out_var )
#   If relevant and possible (e.g. it is a git checkout and git is availablle
#   in the environment), put git versioning information in *out_var*.
#
# A convenience function for use from script-mode for version reporting:
#
# - report_version( version top_dir )
#   Call this with an intended version string (e.g. "1.1") and
#   the top-level source directory (e.g. `${CMAKE_CURRENT_LIST_DIR}`
#   or `${CMAKE_SOURCE_DIR}` .. in script mode, the latter is not defined).
#

function( get_git_version_info out_var )
    set(CMAKE_VERSION_SOURCE "")
    if(EXISTS ${CMAKE_SOURCE_DIR}/.git/HEAD)
        find_program(GIT_EXECUTABLE NAMES git git.cmd)
        mark_as_advanced(GIT_EXECUTABLE)
        if(GIT_EXECUTABLE)
            execute_process(
                COMMAND ${GIT_EXECUTABLE} rev-parse --verify -q --short=8 HEAD
                OUTPUT_VARIABLE head
                OUTPUT_STRIP_TRAILING_WHITESPACE
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            )
            if(head)
                set(CMAKE_VERSION_SOURCE "${head}")
                execute_process(
                    COMMAND ${GIT_EXECUTABLE} update-index -q --refresh
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                )
                execute_process(
                    COMMAND ${GIT_EXECUTABLE} diff-index --name-only HEAD --
                    OUTPUT_VARIABLE dirty
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                )
                if(dirty)
                    set(CMAKE_VERSION_SOURCE "${CMAKE_VERSION_SOURCE}-dirty")
                endif()
            endif()
        endif()
    endif()
    set( ${out_var} "${CMAKE_VERSION_SOURCE}" PARENT_SCOPE )
endfunction()

function( extend_version version short_var long_var )
    set( ${short_var} "${version}" PARENT_SCOPE )

    # Additional info for non-release builds which want "long" version info
    # with date and git information (commit, dirty status).
    set( _v "${version}" )
    string( TIMESTAMP CALAMARES_VERSION_DATE "%Y%m%d" )
    if( CALAMARES_VERSION_DATE GREATER 0 )
        set( _v ${_v}.${CALAMARES_VERSION_DATE} )
    endif()
    get_git_version_info( _gitv )
    if( _gitv )
        set( _v "${_v}-${_gitv}" )
    endif()
    set( ${long_var} "${_v}" PARENT_SCOPE )
endfunction()

function( report_version version top_dir )
    set( CMAKE_SOURCE_DIR ${top_dir} )
    extend_version( ${version} _vshort _vlong )
    if ( "x${VERSION_STYLE}" STREQUAL "xshort" )
        message( "${_vshort}" )
    else()
        message( "${_vlong}" )
    endif()
endfunction()
