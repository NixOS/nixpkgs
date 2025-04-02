# shellcheck shell=bash disable=SC2164

cargoCInstallHook() {
  echo "Executing cargoCInstallHook"

  if [ -n "${buildAndTestSubdir-}" ]; then
    pushd "$buildAndTestSubdir"
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

  echoCmd 'cargoCInstallHook flags' "${flagsArray[@]}"
  @setEnv@ cargo cinstall "${flagsArray[@]}"

  if [ -n "${buildAndTestSubdir-}" ]; then
    popd
  fi

  echo "Finished cargoCInstallHook"
}

if [ -z "${dontCargoCInstall-}"]; then
  appendToVar postInstallHooks cargoCInstallHook
fi
