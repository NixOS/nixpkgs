# shellcheck shell=bash

# occursOnlyOrBeforeInArray
# Tests whether inputElem1 occurs without, or before, inputElem2 in inputArrRef.
#
# Arguments:
# - inputElem1: the first element to check
# - inputElem2: the second element to check
# - inputArrRef: a reference to an array (not mutated)
#
# Returns 0 if inputElem1 occurs and inputElem2 does not, or if inputElem1 occurs before inputElem2.
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
