# shellcheck shell=bash

# sortArray
# Sorts the indexed array referenced by inputArrRef and stores the result in the indexed array referenced by
# outputArrRef.
#
# Arguments:
# - inputArrRef: a reference to an indexed array (not mutated, may alias outputArrRef)
# - outputArrRef: a reference to an indexed array (contents are replaced entirely, may alias inputArrRef)
#
# Returns 0.
sortArray() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: sortArray inputArrRef outputArrRef"
    exit 1
  fi

  local -rn inputArrRef="$1"
  local -rn outputArrRef="$2"

  if ! isDeclaredArray "${!inputArrRef}"; then
    nixErrorLog "first argument inputArrRef must be a reference to an indexed array"
    exit 1
  elif ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "second argument outputArrRef must be a reference to an indexed array"
    exit 1
  fi

  local -a sortedArray=()

  # Guard on the length of the input array, as empty array will expand to nothing, but printf will still see it as an
  # argument, producing an empty string.
  if ((${#inputArrRef[@]} > 0)); then
    # NOTE from Bash's printf documentation:
    #   The format is reused as necessary to consume all of the arguments. If the format requires more arguments than
    #   are supplied, the extra format specifications behave as if a zero value or null string, as appropriate, had
    #   been supplied.
    #   - https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-printf
    # NOTE from sort manpage:
    #   If you use a non-POSIX locale (e.g., by setting LC_ALL to 'en_US'), then sort may produce output that is sorted
    #   differently than you're accustomed to. In that case, set the LC_ALL environment variable to 'C'. Setting only
    #   LC_COLLATE has two problems. First, it is ineffective if LC_ALL is also set. Second, it has undefined behavior
    #   if LC_CTYPE (or LANG, if LC_CTYPE is unset) is set to an incompatible value. For example, you get undefined
    #   behavior if LC_CTYPE is ja_JP.PCK but LC_COLLATE is en_US.UTF-8.
    #   - https://www.gnu.org/software/coreutils/manual/html_node/sort-invocation.html#FOOT1
    mapfile -d $'\0' -t sortedArray < <(printf '%s\0' "${inputArrRef[@]}" | LC_ALL=C sort --stable --zero-terminated)
  fi

  outputArrRef=("${sortedArray[@]}")

  return 0
}
