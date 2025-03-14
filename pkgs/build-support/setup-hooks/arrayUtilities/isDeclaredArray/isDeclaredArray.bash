# shellcheck shell=bash

# Tests if an array is declared.
# NOTE: We must dereference the name ref to get the type of the underlying variable.
isDeclaredArray() {
  # shellcheck disable=SC2034
  local -nr arrayRef="$1" && [[ ${!arrayRef@a} =~ a ]]
}

# Prevent re-declaration
readonly -f isDeclaredArray
