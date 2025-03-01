# shellcheck shell=bash

mapsAreEqual() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: mapsAreEqual inputMap1Ref inputMap2Ref"
    exit 1
  fi

  local -rn inputMap1Ref="$1"
  local -rn inputMap2Ref="$2"

  if ! isDeclaredMap "${!inputMap1Ref}"; then
    nixErrorLog "first arugment inputMap1Ref must be an associative array reference"
    exit 1
  fi

  if ! isDeclaredMap "${!inputMap2Ref}"; then
    nixErrorLog "second arugment inputMap2Ref must be an associative array reference"
    exit 1
  fi

  if ((${#inputMap1Ref[@]} != ${#inputMap2Ref[@]})) ||
    ! mapIsSubmap "${!inputMap1Ref}" "${!inputMap2Ref}" ||
    ! mapIsSubmap "${!inputMap2Ref}" "${!inputMap1Ref}"; then
    return 1
  fi

  return 0
}

# Prevent re-declaration
readonly -f mapsAreEqual
