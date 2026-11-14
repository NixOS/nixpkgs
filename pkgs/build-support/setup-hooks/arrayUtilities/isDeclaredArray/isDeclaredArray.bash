# shellcheck shell=bash

# isDeclaredArray
# Tests if inputArrayRef refers to a declared, indexed array.
#
# Arguments:
# - inputArrayRef: a reference to an indexed array (not mutated)
#
# Returns 0 if the indexed array is declared, 1 otherwise.
isDeclaredArray() {
  # NOTE: We must dereference the name ref to get the type of the underlying variable.
  # shellcheck disable=SC2034
  local -nr inputArrayRef="$1" && [[ ${!inputArrayRef@a} =~ a ]]
}
