# shellcheck shell=bash

set -eu

declare -ag preScriptHooks=(testBuilderExitCode)
# shellcheck disable=SC2154
((${#expectedBuilderLogEntries[@]})) && preScriptHooks+=(testBuilderLogEntries)

testBuilderExitCode() {
  nixLog "checking original builder exit code"
  local -ir builderExitCode=$(<"${failed:?}/testBuildFailure.exit")
  # shellcheck disable=SC2154
  if ((expectedBuilderExitCode == builderExitCode)); then
    nixLog "original builder exit code matches expected value of $expectedBuilderExitCode"
    return 0
  else
    nixErrorLog "original builder produced exit code $builderExitCode but was expected to produce $expectedBuilderExitCode"
    return 1
  fi
}

testBuilderLogEntries() {
  nixLog "checking original builder log"
  local -r builderLogEntries="$(<"${failed:?}/testBuildFailure.log")"
  local -i shouldExit=0
  local expectedBuilderLogEntry
  for expectedBuilderLogEntry in "${expectedBuilderLogEntries[@]}"; do
    if [[ ${builderLogEntries} == *"$expectedBuilderLogEntry"* ]]; then
      nixLog "original builder log contains ${expectedBuilderLogEntry@Q}"
    else
      nixErrorLog "original builder log does not contain ${expectedBuilderLogEntry@Q}"
      shouldExit=1
    fi
  done
  return $shouldExit
}

scriptPhase() {
  runHook preScript

  runHook script

  runHook postScript
}

runHook scriptPhase
touch "${out:?}"
