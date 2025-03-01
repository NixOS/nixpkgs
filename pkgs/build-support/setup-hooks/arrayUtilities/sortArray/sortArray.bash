# shellcheck shell=bash

# TODO: Would it be a mistake to provided an occursInSortedArray?

# Sorts inputArrRef and stores the result in outputArrRef.
# TODO: Is it safe for inputArrRef and outputArrRef to be the same?
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
  fi

  if ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "second arugment outputArrRef must be an array reference"
    exit 1
  fi

  # Early return for empty array, as empty array will expand to nothing, but printf will still see it as an argument,
  # producing an empty string.
  if ((${#inputArrRef[@]} == 0)); then
    outputArrRef=()
    return 0
  fi

  # NOTE from sort manpage: The locale specified by the environment affects sort order. Set LC_ALL=C to get the
  # traditional sort order that uses native byte values.
  mapfile -d $'\0' -t "${!outputArrRef}" < <(printf '%s\0' "${inputArrRef[@]}" | LC_ALL=C sort --stable --zero-terminated)
  return 0
}

# Prevent re-declaration
readonly -f sortArray
