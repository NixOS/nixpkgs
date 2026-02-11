# shellcheck shell=bash

# isDeclaredMap
# Tests if inputMapRef refers to a declared, associative array.
#
# Arguments:
# - inputMapRef: a reference to an associative array (not mutated)
#
# Returns 0 if the associative array is declared, 1 otherwise.
isDeclaredMap() {
  # NOTE: We must dereference the name ref to get the type of the underlying variable.
  # shellcheck disable=SC2034
  local -nr inputMapRef="$1" && [[ ${!inputMapRef@a} =~ A ]]
}
