# shellcheck shell=bash

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
  fi

  if ! isDeclaredArray "${!inputArr2Ref}"; then
    nixErrorLog "second arugment inputArr2Ref must be an array reference"
    exit 1
  fi

  if [[ ${#inputArr1Ref[@]} -ne ${#inputArr2Ref[@]} || ${inputArr1Ref[*]@K} != "${inputArr2Ref[*]@K}" ]]; then
    return 1
  fi

  return 0
}

# Prevent re-declaration
readonly -f arraysAreEqual
