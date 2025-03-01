# shellcheck shell=bash

# Returns 0 if inputElem occurs in inputArrRef, 1 otherwise.
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

# Prevent re-declaration
readonly -f occursInArray
