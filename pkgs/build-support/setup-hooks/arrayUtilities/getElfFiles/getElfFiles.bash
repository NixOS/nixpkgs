# shellcheck shell=bash

# getElfFiles
# Appends the absolute path of each ELF file in the given paths to the output array.
#
# Arguments:
# - outputArrRef: a reference to an array (mutated only by appending)
# - paths: one or more paths to search for ELF files
#
# Returns 0.
getElfFiles() {
  if (($# < 2)); then
    nixErrorLog "expected at least two arguments!"
    nixErrorLog "usage: getElfFiles outputArrRef path [path ...]"
    exit 1
  fi

  # shellcheck disable=SC2178
  local -rn outputArrRef="$1"
  if ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "first arugment outputArrRef must be an array reference"
    exit 1
  fi

  # Shift the first argument (outputArrRef) so that we can process the rest of the arguments as paths.
  shift

  local -i hasInvalidPath=0
  local path
  for path in "$@"; do
    if [[ ! -e $path ]]; then
      nixErrorLog "path $path does not exist"
      hasInvalidPath=1
    fi
  done
  ((hasInvalidPath)) && exit 1
  unset -v hasInvalidPath

  # shellcheck disable=SC2154
  while IFS= read -r -d $'\0' path; do
    if ! isELF "$path"; then
      nixDebugLog "excluding $path because it's not an ELF file"
      continue
    fi

    # NOTE: Since the input is sorted, the output is sorted by virtue of us iterating over it in order.
    outputArrRef+=("$path")

    # NOTE from sort manpage: The locale specified by the environment affects sort order. Set LC_ALL=C to get the
    # traditional sort order that uses native byte values.
  done < <(find "$@" -type f -print0 | LC_ALL=C sort --stable --zero-terminated)

  return 0
}
