# shellcheck shell=bash

# arrayDifference
# Computes the difference of two arrays.
# Arguments:
# - inputArr1Ref: a reference to an array (not mutated)
# - inputArr2Ref: a reference to an array (not mutated)
# - outputArrRef: a reference to an array (mutated)
# Returns 0.
arrayDifference() {
  if (($# != 3)); then
    nixErrorLog "expected three arguments!"
    nixErrorLog "usage: arrayDifference inputArr1Ref inputArr2Ref outputArrRef"
    exit 1
  fi

  local -rn inputArr1Ref="$1"
  local -rn inputArr2Ref="$2"
  # shellcheck disable=SC2178
  # don't warn about outputArrRef being used as an array because it is an array.
  local -rn outputArrRef="$3"

  if ! isDeclaredArray "${!inputArr1Ref}"; then
    nixErrorLog "first arugment inputArr1Ref must be an array reference"
    exit 1
  fi

  if ! isDeclaredArray "${!inputArr2Ref}"; then
    nixErrorLog "second arugment inputArr2Ref must be an array reference"
    exit 1
  fi

  if ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "third arugment outputArrRef must be an array reference"
    exit 1
  fi

  # TODO: Use an O(n) algorithm instead of O(n^2).
  local entry
  for entry in "${inputArr1Ref[@]}"; do
    if ! occursInArray "$entry" "${!inputArr2Ref}"; then
      outputArrRef+=("$entry")
    fi
  done

  return 0
}

# Prevent re-declaration
readonly -f arrayDifference
