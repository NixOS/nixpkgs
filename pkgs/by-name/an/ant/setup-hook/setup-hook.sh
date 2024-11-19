# shellcheck shell=bash
# Setup hook for the Ant build system.
# Full documentation available at /doc/languages-frameworks/ant.section.md

function findExternalAntTasks() {
  if [ -d "$1/share/ant/lib" ]; then
    antFlagsArray+=("-lib" "$1/share/ant/lib")
  fi
}

addEnvHooks "$targetOffset" findExternalAntTasks

function ant() {
  local flagsArray=()
  concatTo flagsArray antFlags antFlagsArray
  command ant "${flagsArray[@]}" "$@"
}

function antBuildPhase() {
  runHook preBuild

  local flagsArray=()
  concatTo flagsArray antBuildFlags antBuildFlagsArray
  ant "${flagsArray[@]}"

  runHook postBuild
}

function antCheckPhase() {
  runHook preCheck

  local flagsArray=()
  concatTo flagsArray antCheckFlags antCheckFlagsArray

  # Set a reasonable default
  if [ ${#flagsArray[@]} -eq 0 ]; then
    flagsArray=("check")
  fi

  ant "${flagsArray[@]}"

  runHook postCheck
}

if [ -z "${dontUseAntBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=antBuildPhase
fi

if [ -z "${dontUseAntCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=antCheckPhase
fi

