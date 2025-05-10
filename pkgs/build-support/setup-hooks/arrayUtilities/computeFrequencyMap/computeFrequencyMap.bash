# shellcheck shell=bash

# computeFrequencyMap
# Produces a frequency map of the elements in an array, incrementing the values in the output map for each occurrence
# of the key in the input array.
#
# Arguments:
# - inputArrRef: a reference to an array (not mutated)
# - outputMapRef: a reference to an associative array (mutated only by incrementing values)
#
# Returns 0.
computeFrequencyMap() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: computeFrequencyMap inputArrRef outputMapRef"
    exit 1
  fi

  local -rn inputArrRef="$1"
  local -rn outputMapRef="$2"

  if ! isDeclaredArray "${!inputArrRef}"; then
    nixErrorLog "first arugment inputArrRef must be an array reference"
    exit 1
  elif ! isDeclaredMap "${!outputMapRef}"; then
    nixErrorLog "second arugment outputMapRef must be an associative array reference"
    exit 1
  fi

  local entry
  for entry in "${inputArrRef[@]}"; do
    # NOTE: entry is not an arithmetic variable, so we must use `$` to get its value.
    # shellcheck disable=SC2004
    outputMapRef[$entry]=$((${outputMapRef[$entry]-0} + 1))
  done

  return 0
}
