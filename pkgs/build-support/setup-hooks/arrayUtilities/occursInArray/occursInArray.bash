# shellcheck shell=bash

# occursInArray
# Tests if an element occurs in an array.
# NOTE: For repeated checks, consider building a map from the array, since tests for membership are typically much
# faster with a map than with an array.
#
# Arguments:
# - inputElem: the element to check for
# - inputArrRef: a reference to an array (not mutated)
#
# Returns 0 if the element occurs in the array, 1 otherwise.
occursInArray() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: occursInArray inputElem inputArrRef"
    exit 1
  fi

  local -r inputElem="$1"
  local -rn inputArrRef="$2"

  if ! isDeclaredArray "${!inputArrRef}"; then
    nixErrorLog "second arugment inputArrRef must be an array reference"
    exit 1
  fi

  local entry
  for entry in "${inputArrRef[@]}"; do
    [[ $entry == "$inputElem" ]] && return 0
  done

  return 1
}
