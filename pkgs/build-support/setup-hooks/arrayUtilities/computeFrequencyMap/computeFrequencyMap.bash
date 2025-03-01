# shellcheck shell=bash

# computeFrequencyMap
# Produces a frequency map of the elements in an array.
#
# Arguments:
# - inputArrRef: a reference to an array (not mutated)
# - outputMapRef: a reference to an associative array (mutated)
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
  fi

  if ! isDeclaredMap "${!outputMapRef}"; then
    nixErrorLog "second arugment outputMapRef must be an associative array reference"
    exit 1
  fi

  local -i numTimesSeen
  local entry
  for entry in "${inputArrRef[@]}"; do
    numTimesSeen=$((${outputMapRef["$entry"]-0} + 1))
    outputMapRef["$entry"]=$numTimesSeen
  done

  return 0
}

# Prevent re-declaration
readonly -f computeFrequencyMap
