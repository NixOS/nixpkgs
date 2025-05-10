# shellcheck shell=bash

# deduplicateArray
# Deduplicates an array, appending the result to the output array.
# If outputMapRef is provided, it will contain the frequency of each element in the input array.
#
# Arguments:
# - inputArrRef: a reference to an array (not mutated, cannot alias outputArrRef)
# - outputArrRef: a reference to an array (mutated only by appending, cannot alias inputArrRef)
# - outputMapRef: a reference to an associative array (optional, mutated only by incrementing values)
#
# Returns 0.
deduplicateArray() {
  if (($# != 2 && $# != 3)); then
    nixErrorLog "expected two or three arguments!"
    nixErrorLog "usage: deduplicateArray inputArrRef outputArrRef [outputMapRef]"
    exit 1
  fi

  local -rn inputArrRef="$1"
  # shellcheck disable=SC2178
  # don't warn about outputArrRef being used as an array because it is an array.
  local -rn outputArrRef="$2"
  # shellcheck disable=SC2034
  # outputMap is used in outputMapRef
  local -A outputMap=()
  # shellcheck disable=SC2178
  # don't warn about outputMapRef being used as an array because it is an array.
  local -rn outputMapRef="${3:-outputMap}"

  if ! isDeclaredArray "${!inputArrRef}"; then
    nixErrorLog "first arugment inputArrRef must be an array reference"
    exit 1
  elif ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "second arugment outputArrRef must be an array reference"
    exit 1
  elif [[ ${!outputArrRef} == "${!inputArrRef}" ]]; then
    nixErrorLog "second arugment outputArrRef must not alias first argument inputArrRef"
    exit 1
  elif ! isDeclaredMap "${!outputMapRef}"; then
    nixErrorLog "third arugment outputMapRef must be an associative array reference when present"
    exit 1
  fi

  local -i numTimesSeen
  local entry
  for entry in "${inputArrRef[@]}"; do
    numTimesSeen=$((${outputMapRef[$entry]-0} + 1))
    # NOTE: entry is not an arithmetic variable, so we must use `$` to get its value.
    # shellcheck disable=SC2004
    outputMapRef[$entry]=$numTimesSeen

    if ((numTimesSeen == 1)); then
      outputArrRef+=("$entry")
    fi
  done

  return 0
}
