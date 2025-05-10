# shellcheck shell=bash

# arrayDifference
# Computes the set-theoretic difference of two arrays, appending the elements which occur in the first input array
# but not the second to the output array.
#
# Arguments:
# - inputArr1Ref: a reference to an array (not mutated, cannot alias outputArrRef)
# - inputArr2Ref: a reference to an array (not mutated, cannot alias outputArrRef)
# - outputArrRef: a reference to an array (mutated only by appending, cannot alias inputArr1Ref or inputArr2Ref)
#
# Returns 0.
arrayDifference() {
  if (($# != 3)); then
    nixErrorLog "expected three arguments!"
    nixErrorLog "usage: arrayDifference inputArr1Ref inputArr2Ref outputArrRef"
    exit 1
  fi

  local -rn inputArr1Ref="$1"
  local -rn inputArr2Ref="$2"
  # shellcheck disable=SC2178
  # don't warn about outputArrRef being used as an array because it is an array.
  local -rn outputArrRef="$3"

  if ! isDeclaredArray "${!inputArr1Ref}"; then
    nixErrorLog "first arugment inputArr1Ref must be an array reference"
    exit 1
  elif ! isDeclaredArray "${!inputArr2Ref}"; then
    nixErrorLog "second arugment inputArr2Ref must be an array reference"
    exit 1
  elif ! isDeclaredArray "${!outputArrRef}"; then
    nixErrorLog "third arugment outputArrRef must be an array reference"
    exit 1
  elif [[ ${!outputArrRef} == "${!inputArr1Ref}" ]]; then
    nixErrorLog "third argument outputArrRef must not alias first argument inputArr1Ref"
    exit 1
  elif [[ ${!outputArrRef} == "${!inputArr2Ref}" ]]; then
    nixErrorLog "third argument outputArrRef must not alias second argument inputArr2Ref"
    exit 1
  fi

  # Compute the frequency map of the second array to allow O(1) membership tests.
  local -A freqMap=()
  computeFrequencyMap "${!inputArr2Ref}" freqMap

  local entry
  for entry in "${inputArr1Ref[@]}"; do
    # If the entry is not in the second array, add it to the output array.
    # NOTE: Recall that arithmetic expressions which evalute to 0 produce a return code of 1, while those which evlaute
    # to a non-zero value produce a return code of 0.
    # NOTE: Supply a default because we may be used with `nounset`.
    # NOTE: Omit `:` because the value will never be null.
    if ! ((${freqMap[$entry]-0})); then
      outputArrRef+=("$entry")
    fi
  done

  return 0
}
