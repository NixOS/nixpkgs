# shellcheck shell=bash

# Returns 0 if inputElem1 occurs after inputElem2 in inputArrRef or if inputElem1 occurs and inputElem2 does not.
# Returns 1 otherwise.
occursOnlyOrAfterInArray() {
  if (($# != 3)); then
    nixErrorLog "expected three arguments!"
    nixErrorLog "usage: occursOnlyOrAfterInArray inputElem1 inputElem2 inputArrRef"
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

  local -i seenInputElem1=0
  local -i seenInputElem2=0
  local entry
  for entry in "${inputArrRef[@]}"; do
    if [[ $entry == "$inputElem1" ]]; then
      # If we've already seen inputElem2, then inputElem1 occurs after inputElem2 and we can return success.
      ((seenInputElem2)) && return 0
      # Otherwise, we've seen inputElem1 and are waiting to see if inputElem2 occurs.
      seenInputElem1=1
    elif [[ $entry == "$inputElem2" ]]; then
      # Since we've seen inputElem2, we can return failure if we've already seen inputElem1.
      ((seenInputElem1)) && return 1
      # Otherwise, we've seen inputElem2 and are waiting to see if inputElem1 occurs.
      seenInputElem2=1
    fi
  done

  # Due to the structure of the return statements, when we exit the for loop, we know that at most one of the
  # input elements has been seen.
  # If we've seen inputElem1, then we know that inputElem2 didn't occur, so we return success.
  # If we haven't seen inputElem1, it doesn't matter if we've seen inputElem2 or not -- we return failure.
  return $((1 - seenInputElem1))
}

# Prevent re-declaration
readonly -f occursOnlyOrAfterInArray
