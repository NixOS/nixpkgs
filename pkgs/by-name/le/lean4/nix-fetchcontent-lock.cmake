# FetchContent dependency provider: append lock lines for MakeAvailable calls.
# Does not call FetchContent_SetPopulated (population still runs if needed).

cmake_minimum_required(VERSION 3.24)

set(NIX_FC_LOCKFILE "${CMAKE_BINARY_DIR}/fetchcontent-lock.jsonl"
  CACHE FILEPATH "JSONL lock of FetchContent_MakeAvailable requests")

file(WRITE "${NIX_FC_LOCKFILE}" "")

function(nix_record_dependency method)
  if(NOT method STREQUAL "FETCHCONTENT_MAKEAVAILABLE_SERIAL")
    return()
  endif()

  set(_args "${ARGN}")
  list(LENGTH _args _n)
  if(_n LESS 1)
    return()
  endif()

  list(GET _args 0 _name)
  list(REMOVE_AT _args 0)

  # Walk tokens; CMake may insert EXTERNALPROJECT_INTERNAL_ARGUMENT_SEPARATOR
  # and boolean flags (EXCLUDE_FROM_ALL) without values. Only capture known keys.
  set(_git_repository "")
  set(_git_tag "")
  set(_url "")
  set(_url_hash "")

  set(_i 0)
  list(LENGTH _args _n)
  while(_i LESS _n)
    list(GET _args ${_i} _tok)
    math(EXPR _i "${_i}+1")

    if(_tok STREQUAL "EXTERNALPROJECT_INTERNAL_ARGUMENT_SEPARATOR")
      # ignore separator inserted by FetchContent internals
    elseif(
      _tok STREQUAL "EXCLUDE_FROM_ALL"
      OR _tok STREQUAL "SYSTEM"
      OR _tok STREQUAL "OVERRIDE_FIND_PACKAGE"
    )
      # flags without values
    elseif(
      _tok STREQUAL "GIT_REPOSITORY"
      OR _tok STREQUAL "GIT_TAG"
      OR _tok STREQUAL "URL"
      OR _tok STREQUAL "URL_HASH"
      OR _tok STREQUAL "SOURCE_DIR"
      OR _tok STREQUAL "BINARY_DIR"
      OR _tok STREQUAL "GIT_SHALLOW"
      OR _tok STREQUAL "GIT_PROGRESS"
      OR _tok STREQUAL "TLS_VERIFY"
      OR _tok STREQUAL "FIND_PACKAGE_ARGS"
    )
      if(_i LESS _n)
        list(GET _args ${_i} _val)
        math(EXPR _i "${_i}+1")
        if(_tok STREQUAL "GIT_REPOSITORY")
          set(_git_repository "${_val}")
        elseif(_tok STREQUAL "GIT_TAG")
          set(_git_tag "${_val}")
        elseif(_tok STREQUAL "URL")
          set(_url "${_val}")
        elseif(_tok STREQUAL "URL_HASH")
          set(_url_hash "${_val}")
        endif()
      endif()
    endif()
  endwhile()

  # Escape for JSON string values
  set(_ename "${_name}")
  string(REPLACE "\\" "\\\\" _ename "${_ename}")
  string(REPLACE "\"" "\\\"" _ename "${_ename}")

  set(_json "{\"name\":\"${_ename}\"")
  if(NOT _git_repository STREQUAL "")
    set(_e "${_git_repository}")
    string(REPLACE "\\" "\\\\" _e "${_e}")
    string(REPLACE "\"" "\\\"" _e "${_e}")
    string(APPEND _json ",\"GIT_REPOSITORY\":\"${_e}\"")
  endif()
  if(NOT _git_tag STREQUAL "")
    set(_e "${_git_tag}")
    string(REPLACE "\\" "\\\\" _e "${_e}")
    string(REPLACE "\"" "\\\"" _e "${_e}")
    string(APPEND _json ",\"GIT_TAG\":\"${_e}\"")
  endif()
  if(NOT _url STREQUAL "")
    set(_e "${_url}")
    string(REPLACE "\\" "\\\\" _e "${_e}")
    string(REPLACE "\"" "\\\"" _e "${_e}")
    string(APPEND _json ",\"URL\":\"${_e}\"")
  endif()
  if(NOT _url_hash STREQUAL "")
    set(_e "${_url_hash}")
    string(REPLACE "\\" "\\\\" _e "${_e}")
    string(REPLACE "\"" "\\\"" _e "${_e}")
    string(APPEND _json ",\"URL_HASH\":\"${_e}\"")
  endif()
  string(APPEND _json "}")
  file(APPEND "${NIX_FC_LOCKFILE}" "${_json}\n")
endfunction()

cmake_language(
  SET_DEPENDENCY_PROVIDER nix_record_dependency
  SUPPORTED_METHODS FETCHCONTENT_MAKEAVAILABLE_SERIAL
)
