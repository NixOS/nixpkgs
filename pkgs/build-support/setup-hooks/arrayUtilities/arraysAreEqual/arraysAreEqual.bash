# shellcheck shell=bash

# arraysAreEqual
# Compares two arrays for equality.
#
# Arguments:
# - inputArr1Ref: a reference to an array (not mutated)
# - inputArr2Ref: a reference to an array (not mutated)
#
# Returns 0 if the arrays are equal, 1 otherwise.
arraysAreEqual() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: arraysAreEqual inputArr1Ref inputArr2Ref"
    exit 1
  fi

  local -rn inputArr1Ref="$1"
  local -rn inputArr2Ref="$2"

  if ! isDeclaredArray "${!inputArr1Ref}"; then
    nixErrorLog "first arugment inputArr1Ref must be an array reference"
    exit 1
  elif ! isDeclaredArray "${!inputArr2Ref}"; then
    nixErrorLog "second arugment inputArr2Ref must be an array reference"
    exit 1
  fi

  if ((${#inputArr1Ref[@]} == ${#inputArr2Ref[@]})) &&
    [[ ${inputArr1Ref[*]@K} == "${inputArr2Ref[*]@K}" ]]; then
    return 0
  fi

  return 1
}
