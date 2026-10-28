# shellcheck shell=bash

# Asserts that two maps are equal, printing out differences if they are not.
# Does not short circuit on the first difference.
assertEqualMap() {
  if (($# != 2)); then
    nixErrorLog "expected two arguments!"
    nixErrorLog "usage: assertEqualMap expectedMapRef actualMapRef"
    exit 1
  fi

  local -nr expectedMapRef="$1"
  local -nr actualMapRef="$2"

  if ! isDeclaredMap "${!expectedMapRef}"; then
    nixErrorLog "first argument expectedMapRef must be a reference to an associative array"
    exit 1
  fi

  if ! isDeclaredMap "${!actualMapRef}"; then
    nixErrorLog "second argument actualMapRef must be a reference to an associative array"
    exit 1
  fi

  local -ir expectedLength=${#expectedMapRef[@]}
  local -ir actualLength=${#actualMapRef[@]}

  local -i hasDiff=0

  if ((expectedLength != actualLength)); then
    nixErrorLog "maps differ in length: expectedMap has length $expectedLength but actualMap has length $actualLength"
    hasDiff=1
  fi

  local -a sortedExpectedKeys=()
  getSortedMapKeys "${!expectedMapRef}" sortedExpectedKeys

  local -a sortedActualKeys=()
  getSortedMapKeys "${!actualMapRef}" sortedActualKeys

  local -i expectedKeyIdx=0
  local expectedKey
  local expectedValue
  local -i actualKeyIdx=0
  local actualKey
  local actualValue

  # We iterate so long as at least one map has keys we've not considered.
  while ((expectedKeyIdx < expectedLength || actualKeyIdx < actualLength)); do
    # Update values for variables which are still in range/valid.
    if ((expectedKeyIdx < expectedLength)); then
      expectedKey="${sortedExpectedKeys["$expectedKeyIdx"]}"
      expectedValue="${expectedMapRef["$expectedKey"]}"
    fi

    if ((actualKeyIdx < actualLength)); then
      actualKey="${sortedActualKeys["$actualKeyIdx"]}"
      actualValue="${actualMapRef["$actualKey"]}"
    fi

    # In the case actualKeyIdx is valid and expectedKey comes after actualKey or expectedKeyIdx is invalid, actualMap
    # has an extra key relative to expectedMap.
    # NOTE: In Bash, && and || have the same precedence, so use the fact they're left-associative to enforce groups.
    if ((actualKeyIdx < actualLength)) && [[ $expectedKey > $actualKey ]] || ((expectedKeyIdx >= expectedLength)); then
      nixErrorLog "maps differ at key ${actualKey@Q}: expectedMap has no such key but actualMap has value ${actualValue@Q}"
      hasDiff=1
      actualKeyIdx+=1

    # In the case actualKeyIdx is invalid or expectedKey comes before actualKey, expectedMap has an extra key relative
    # to actualMap.
    # NOTE: By virtue of the previous condition being false, we know the negation is true. Namely, expectedKeyIdx is
    # valid AND (actualKeyIdx is invalid OR expectedKey <= actualKey).
    elif ((actualKeyIdx >= actualLength)) || [[ $expectedKey < $actualKey ]]; then
      nixErrorLog "maps differ at key ${expectedKey@Q}: expectedMap has value ${expectedValue@Q} but actualMap has no such key"
      hasDiff=1
      expectedKeyIdx+=1

    # In the case where both key indices are valid and the keys are equal.
    else
      if [[ $expectedValue != "$actualValue" ]]; then
        nixErrorLog "maps differ at key ${expectedKey@Q}: expectedMap has value ${expectedValue@Q} but actualMap has value ${actualValue@Q}"
        hasDiff=1
      fi

      expectedKeyIdx+=1
      actualKeyIdx+=1
    fi
  done

  ((hasDiff)) && exit 1 || return 0
}
