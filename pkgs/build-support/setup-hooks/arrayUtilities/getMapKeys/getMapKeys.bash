# shellcheck shell=bash

# getMapKeys
# Appends a sorted array of the keys of the input associative array to the output arrray.
#
# Arguments:
# - inputMapRef: a reference to an associative array (not mutated)
# - outputArrRef: a reference to an array (mutated only by appending)
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
  elif ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "second arugment outputArrRef must be an array reference"
    exit 1
  fi

  # shellcheck disable=SC2034
  local -a keys=("${!inputMapRef[@]}")
  local -a sortedKeys=()
  sortArray keys sortedKeys

  # Append the sorted keys to the output array.
  outputArrRef+=("${sortedKeys[@]}")

  return 0
}
