# shellcheck shell=bash

# sortArray
# Sorts inputArrRef and stores the result in outputArrRef.
#
# Arguments:
# - inputArrRef: a reference to an array (not mutated)
# - outputArrRef: a reference to an array (mutated only by appending)
#
# Returns 0.
sortArray() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: sortArray inputArrRef outputArrRef"
    exit 1
  fi

  local -rn inputArrRef="$1"
  local -rn outputArrRef="$2"

  if ! isDeclaredArray "${!inputArrRef}"; then
    nixErrorLog "first arugment inputArrRef must be an array reference"
    exit 1
  elif ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "second arugment outputArrRef must be an array reference"
    exit 1
  fi

  local -a sortedArr=()

  # Guard on the length of the input array, as empty array will expand to nothing, but printf will still see it as an argument,
  # producing an empty string.
  if ((${#inputArrRef[@]} > 0)); then
    # NOTE from sort manpage: The locale specified by the environment affects sort order. Set LC_ALL=C to get the
    # traditional sort order that uses native byte values.
    mapfile -d $'\0' -t sortedArr < <(printf '%s\0' "${inputArrRef[@]}" | LC_ALL=C sort --stable --zero-terminated)
  fi

  # Append the sorted array to the output array.
  outputArrRef+=("${sortedArr[@]}")

  return 0
}
