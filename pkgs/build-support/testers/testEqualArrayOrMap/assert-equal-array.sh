# shellcheck shell=bash

# Tests if an array is declared.
isDeclaredArray() {
  # shellcheck disable=SC2034
  local -nr arrayRef="$1" && [[ ${!arrayRef@a} =~ a ]]
}

# Asserts that two arrays are equal, printing out differences if they are not.
# Does not short circuit on the first difference.
assertEqualArray() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: assertEqualArray expectedArrayRef actualArrayRef"
    exit 1
  fi

  local -nr expectedArrayRef="$1"
  local -nr actualArrayRef="$2"

  if ! isDeclaredArray "${!expectedArrayRef}"; then
    nixErrorLog "first arugment expectedArrayRef must be an array reference to a declared array"
    exit 1
  fi

  if ! isDeclaredArray "${!actualArrayRef}"; then
    nixErrorLog "second arugment actualArrayRef must be an array reference to a declared array"
    exit 1
  fi

  local -ir expectedLength=${#expectedArrayRef[@]}
  local -ir actualLength=${#actualArrayRef[@]}

  local -i hasDiff=0

  if ((expectedLength != actualLength)); then
    nixErrorLog "arrays differ in length: expectedArray has length $expectedLength but actualArray has length $actualLength"
    hasDiff=1
  fi

  local -i idx=0
  local expectedValue
  local actualValue

  # We iterate so long as at least one array has indices we've not considered.
  # This means that `idx` is a valid index to *at least one* of the arrays.
  for ((idx = 0; idx < expectedLength || idx < actualLength; idx++)); do
    # Update values for variables which are still in range/valid.
    if ((idx < expectedLength)); then
      expectedValue="${expectedArrayRef[idx]}"
    fi

    if ((idx < actualLength)); then
      actualValue="${actualArrayRef[idx]}"
    fi

    # Handle comparisons.
    if ((idx >= expectedLength)); then
      nixErrorLog "arrays differ at index $idx: expectedArray has no such index but actualArray has value ${actualValue@Q}"
      hasDiff=1
    elif ((idx >= actualLength)); then
      nixErrorLog "arrays differ at index $idx: expectedArray has value ${expectedValue@Q} but actualArray has no such index"
      hasDiff=1
    elif [[ $expectedValue != "$actualValue" ]]; then
      nixErrorLog "arrays differ at index $idx: expectedArray has value ${expectedValue@Q} but actualArray has value ${actualValue@Q}"
      hasDiff=1
    fi
  done

  ((hasDiff)) && exit 1 || return 0
}
