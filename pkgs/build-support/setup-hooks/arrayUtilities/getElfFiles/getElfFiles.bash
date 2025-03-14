# shellcheck shell=bash

# Populate outputArrRef with the ELF files in the given path.
getElfFiles() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: getElfFiles path outputArrRef"
    exit 1
  fi

  local -r path="$1"
  # shellcheck disable=SC2178
  local -rn outputArrRef="$2"

  if [[ ! -d $path ]]; then
    nixErrorLog "path $path is not a directory"
    exit 1
  elif ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "first arugment outputArrRef must be an array reference"
    exit 1
  fi

  # TODO: does `-type f` prevent inclusion of symlinks?
  local file
  # shellcheck disable=SC2154
  while IFS= read -r -d $'\0' file; do
    if ! isELF "$file"; then
      nixLog "excluding $file because it's not an ELF file"
      continue
    fi

    # NOTE: Since the input is sorted, the output is sorted by virtue of us iterating over it in order.
    nixLog "including $file"
    outputArrRef+=("$file")

    # NOTE from sort manpage: The locale specified by the environment affects sort order. Set LC_ALL=C to get the
    # traditional sort order that uses native byte values.
  done < <(find "$path" -type f -print0 | LC_ALL=C sort --stable --zero-terminated)

  return 0
}

# Prevent re-declaration
readonly -f getElfFiles
