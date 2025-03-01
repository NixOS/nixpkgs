# shellcheck shell=bash

# Returns 0 if inputElem1 occurs before inputElem2 in inputArrRef or if inputElem1 occurs and inputElem2 does not.
# Returns 1 otherwise.
occursOnlyOrBeforeInArray() {
  if (($# != 3)); then
    nixErrorLog "expected three arguments!"
    nixErrorLog "usage: occursOnlyOrBeforeInArray inputElem1 inputElem2 inputArrRef"
    exit 1
  fi

  local -r inputElem1="$1"
  local -r inputElem2="$2"
  local -rn inputArrRef="$3"

  if ! isDeclaredArray "${!inputArrRef}"; then
    nixErrorLog "third arugment inputArrRef must be an array reference"
    exit 1
  fi

  if [[ $inputElem1 == "$inputElem2" ]]; then
    nixErrorLog "inputElem1 and inputElem2 must be different"
    exit 1
  fi

  local entry
  for entry in "${inputArrRef[@]}"; do
    # Early return on finding inputElem1
    [[ $entry == "$inputElem1" ]] && return 0
    # Stop searching if we find inputElem2
    [[ $entry == "$inputElem2" ]] && break
  done

  return 1
}

# Prevent re-declaration
readonly -f occursOnlyOrBeforeInArray
