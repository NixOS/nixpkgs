# shellcheck shell=bash

# getMapKeys
# Returns a sorted array of the keys of inputMapRef.
#
# Arguments:
# - inputMapRef: a reference to an associative array (not mutated)
# - outputArrRef: a reference to an array (mutated)
#
# Returns 0.
getMapKeys() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: getMapKeys inputMapRef outputArrRef"
    exit 1
  fi

  local -rn inputMapRef="$1"
  # shellcheck disable=SC2178
  # Don't warn about outputArrRef being used as an array because it is an array.
  local -rn outputArrRef="$2"

  if ! isDeclaredMap "${!inputMapRef}"; then
    nixErrorLog "first arugment inputMapRef must be an associative array reference"
    exit 1
  fi

  if ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "second arugment outputArrRef must be an array reference"
    exit 1
  fi

  # shellcheck disable=SC2034
  local -a keys=("${!inputMapRef[@]}")
  sortArray keys "${!outputArrRef}"
  return 0
}
