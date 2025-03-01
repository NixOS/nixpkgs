# shellcheck shell=bash

# getRunpathEntries
# Populate outputArrRef with the runpath entries of path.
# NOTE: This function does not check if path is a valid ELF file.
#
# Arguments:
# - path: the path to the ELF file
# - outputArrRef: a reference to an array (mutated)
#
# Returns 0.
getRunpathEntries() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: getRunpathEntries path outputArrRef"
    exit 1
  fi

  local -r path="$1"
  # shellcheck disable=SC2178
  local -rn outputArrRef="$2"

  if [[ ! -f $path ]]; then
    nixErrorLog "path $path is not a file"
    exit 1
  elif ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "second arugment outputArrRef must be an array reference"
    exit 1
  fi

  local -r runpath="$(patchelf --print-rpath "$path")"

  if [[ -z $runpath ]]; then
    outputArrRef=()
  else
    mapfile -d ':' -t "${!outputArrRef}" < <(echo -n "$runpath")
  fi

  return 0
}
