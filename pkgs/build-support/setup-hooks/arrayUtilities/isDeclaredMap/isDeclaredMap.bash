# shellcheck shell=bash

# Tests if a map is declared.
# NOTE: We must dereference the name ref to get the type of the underlying variable.
isDeclaredMap() {
  # shellcheck disable=SC2034
  local -nr mapRef="$1" && [[ ${!mapRef@a} =~ A ]]
}

# Prevent re-declaration
readonly -f isDeclaredMap
