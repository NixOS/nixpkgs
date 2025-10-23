# shellcheck shell=bash

_addDLLPaths() {
  # this reverts part of what strictDeps does, but this is needed for DLLs to be
  # found before cygwin-dll-link runs
  addToSearchPath "_PATH" "$1/bin"
}

# shellcheck disable=SC2154
addEnvHooks "$targetOffset" _addDLLPaths
