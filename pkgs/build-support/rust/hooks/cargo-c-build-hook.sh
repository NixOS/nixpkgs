# shellcheck shell=bash disable=SC2514,SC2164

cargoCBuildHook() {
  echo "Executing cargoCBuildHook"

  # let stdenv handle stripping
  export "CARGO_PROFILE_${cargoBuildType@U}_STRIP"=false

  if [ -n "${buildAndTestSubdir-}" ]; then
    # ensure the output doesn't end up in the subdirectory
    CARGO_TARGET_DIR="$(pwd)/target"
    export CARGO_TARGET_DIR

    pushd "${buildAndTestSubdir}"
  fi

  local -a flagsArray
  concatTo flagsArray cargoCFlags cargoCInstallFlags

  if [ "${cargoBuildType}" != "debug" ]; then
    flagsArray+=("--profile" "${cargoBuildType}")
  fi

  if [ -n "${cargoBuildNoDefaultFeatures-}" ]; then
    flagsArray+=("--no-default-features")
  fi

  if [ -n "${cargoBuildFeatures-}" ]; then
    flagsArray+=("--features=$(concatStringsSep "," cargoBuildFeatures)")
  fi

  concatTo flagsArray cargoBuildFlags

  echoCmd 'cargoCBuildHook flags' "${flagsArray[@]}"
  @setEnv@ cargo cbuild "${flagsArray[@]}"

  if [ -n "${buildAndTestSubdir-}" ]; then
    popd
  fi

  echo "Finished cargoCBuildHook"
}

if [ -z "${dontCargoCBuild-}" ]; then
  postBuildHooks+=(cargoCBuildHook)
fi
