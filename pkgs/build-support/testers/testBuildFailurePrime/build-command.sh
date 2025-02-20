# shellcheck shell=bash

set -eu

scriptPhase() {
  runHook preScript

  nixLog "checking original builder exit code"
  local -ir builderExitCode=$(<"${failed:?}/testBuildFailure.exit")
  # shellcheck disable=SC2154
  if ((expectedBuilderExitCode == builderExitCode)); then
    nixLog "original builder exit code matches expected value of $expectedBuilderExitCode"
  else
    nixErrorLog "original builder produced exit code $builderExitCode but was expected to produce $expectedBuilderExitCode"
    exit 1
  fi

  # shellcheck disable=SC2154
  if ((${#expectedBuilderLogEntries[@]})); then
    nixLog "checking original builder log"
    local -r builderLogEntries="$(<"${failed:?}/testBuildFailure.log")"
    local -i shouldExit=0
    for expectedBuilderLogEntry in "${expectedBuilderLogEntries[@]}"; do
      if [[ ${builderLogEntries} == *"$expectedBuilderLogEntry"* ]]; then
        nixLog "original builder log contains ${expectedBuilderLogEntry@Q}"
      else
        nixErrorLog "original builder log does not contain ${expectedBuilderLogEntry@Q}"
        shouldExit=1
      fi
    done
    ((shouldExit)) && exit 1
  fi

  runHook script

  runHook postScript
}

runHook scriptPhase
touch "${out:?}"
