# shellcheck shell=bash

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
  fi

  if ! isDeclaredMap "${!supermapRef}"; then
    nixErrorLog "second arugment supermapRef must be an associative array reference"
    exit 1
  fi

  local subMapKey
  for subMapKey in "${!submapRef[@]}"; do
    [[ ${submapRef["$subMapKey"]} != "${supermapRef["$subMapKey"]}" ]] && return 1
  done

  return 0
}

# Prevent re-declaration
readonly -f mapIsSubmap
