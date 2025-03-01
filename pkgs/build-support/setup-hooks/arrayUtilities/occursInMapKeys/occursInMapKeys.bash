# shellcheck shell=bash

# Returns 0 if inputElem occurs in the keys of inputMapRef, 1 otherwise.
# NOTE: This is O(n) in the size of the map, but allows testing for keys with values which
# are empty strings (normally considered unset).
occursInMapKeys() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: occursInMapKeys inputElem inputMapRef"
    exit 1
  fi

  local -r inputElem="$1"
  local -rn inputMapRef="$2"

  if ! isDeclaredMap "${!inputMapRef}"; then
    nixErrorLog "second arugment inputMapRef must be an associative array reference"
    exit 1
  fi

  # shellcheck disable=SC2034
  # keys is used in getMapKeys
  local -a keys
  getMapKeys "${!inputMapRef}" keys
  occursInArray "$inputElem" keys
  return $? # Return the result of occursInArray
}

# Prevent re-declaration
readonly -f occursInMapKeys
