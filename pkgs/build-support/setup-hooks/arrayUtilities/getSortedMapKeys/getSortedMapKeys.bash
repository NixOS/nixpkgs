# shellcheck shell=bash

# getSortedMapKeys
# Stores the sorted keys of the input associative array referenced by inputMapRef in the indexed arrray referenced by
# outputArrRef.
#
# Note from the Bash manual on arrays:
#   There is no maximum limit on the size of an array, nor any requirement that members be indexed or assigned contiguously.
#   - https://www.gnu.org/software/bash/manual/html_node/Arrays.html
#
# Since no guarantees are made about the order in which associative maps are traversed, this function is primarly
# useful for getting rid of yet another source of non-determinism. As an added benefit, it checks that the arguments
# provided are of correct type, unlike native parameter expansion which will accept expansions of strings.
#
# Arguments:
# - inputMapRef: a reference to an associative array (not mutated)
# - outputArrRef: a reference to an indexed array (contents are replaced entirely)
#
# Returns 0.
getSortedMapKeys() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: getSortedMapKeys inputMapRef outputArrRef"
    exit 1
  fi

  local -rn inputMapRef="$1"
  # shellcheck disable=SC2178
  # Don't warn about outputArrRef being used as an array because it is an array.
  local -rn outputArrRef="$2"

  if ! isDeclaredMap "${!inputMapRef}"; then
    nixErrorLog "first argument inputMapRef must be a reference to an associative array"
    exit 1
  elif ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "second argument outputArrRef must be a reference to an indexed array"
    exit 1
  fi

  # shellcheck disable=SC2034
  local -a keys=("${!inputMapRef[@]}")
  sortArray keys "${!outputArrRef}"

  return 0
}
