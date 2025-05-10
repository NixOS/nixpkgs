# shellcheck shell=bash

# mapIsSubmap
# Compares two associative arrays to determine if the first is a submap of the second.
#
# Arguments:
# - submapRef: a reference to an associative array (not mutated)
# - supermapRef: a reference to an associative array (not mutated)
#
# Returns 0 if the first map is a submap of the second, 1 otherwise.
mapIsSubmap() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: mapIsSubmap submapRef supermapRef"
    exit 1
  fi

  local -rn submapRef="$1"
  local -rn supermapRef="$2"

  if ! isDeclaredMap "${!submapRef}"; then
    nixErrorLog "first arugment submapRef must be an associative array reference"
    exit 1
  elif ! isDeclaredMap "${!supermapRef}"; then
    nixErrorLog "second arugment supermapRef must be an associative array reference"
    exit 1
  fi

  local subMapKey
  for subMapKey in "${!submapRef[@]}"; do
    if ! occursInMapKeys "$subMapKey" "${!supermapRef}" ||
      [[ ${submapRef[$subMapKey]} != "${supermapRef[$subMapKey]}" ]]; then
      return 1
    fi
  done

  return 0
}
