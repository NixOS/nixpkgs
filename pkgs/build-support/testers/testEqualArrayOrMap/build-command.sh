# shellcheck shell=bash

set -eu

preScript() {
  # If neither expectedArray nor expectedMap are declared, the test is meaningless.
  if ! isDeclaredArray expectedArray && ! isDeclaredMap expectedMap; then
    nixErrorLog "neither expectedArray nor expectedMap were set, so test is meaningless!"
    exit 1
  fi

  if isDeclaredArray valuesArray; then
    # shellcheck disable=SC2154
    nixLog "using valuesArray: $(declare -p valuesArray)"
  fi

  if isDeclaredMap valuesMap; then
    # shellcheck disable=SC2154
    nixLog "using valuesMap: $(declare -p valuesMap)"
  fi

  if isDeclaredArray expectedArray; then
    # shellcheck disable=SC2154
    nixLog "using expectedArray: $(declare -p expectedArray)"
    declare -ag actualArray=()
  fi

  if isDeclaredMap expectedMap; then
    # shellcheck disable=SC2154
    nixLog "using expectedMap: $(declare -p expectedMap)"
    declare -Ag actualMap=()
  fi

  return 0
}

scriptPhase() {
  runHook preScript

  runHook script

  runHook postScript
}

postScript() {
  if isDeclaredArray expectedArray; then
    nixLog "using actualArray: $(declare -p actualArray)"
    nixLog "comparing actualArray against expectedArray"
    assertEqualArray expectedArray actualArray
    nixLog "actualArray matches expectedArray"
  fi

  if isDeclaredMap expectedMap; then
    nixLog "using actualMap: $(declare -p actualMap)"
    nixLog "comparing actualMap against expectedMap"
    assertEqualMap expectedMap actualMap
    nixLog "actualMap matches expectedMap"
  fi

  return 0
}

runHook scriptPhase
touch "${out:?}"
