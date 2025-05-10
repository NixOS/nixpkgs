# shellcheck shell=bash

# occursInMapKeys
# Checks if a key occurs in the keys of a map.
#
# Arguments:
# - inputElem: a string representing the key to check
# - inputMapRef: a reference to an associative array (not mutated)
#
# Returns 0 if the key occurs in the map, 1 otherwise.
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

  # Check if the key is absent in the associative array by verifying that the distinct default values for unset keys
  # are returned for both possible expansions of the key.
  if [[ ${inputMapRef[$inputElem]-0} == "0" && ${inputMapRef[$inputElem]-1} == "1" ]]; then
    return 1
  fi

  return 0
}
