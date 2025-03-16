cargoCCheckHook() {
  echo "Executing cargoCCheckHook"

  if [ -n "${buildAndTestSubdir-}" ]; then
    pushd "${buildAndTestSubdir}"
  fi

  local -a flagsArray
  concatTo flagsArray cargoCFlags

  export RUST_TEST_THREADS="$NIX_BUILD_CORES"
  if [ -n "${dontUseCargoParallelTests-}" ]; then
    RUST_TEST_THREADS=1
  fi

  if [ "${cargoCheckType}" != "debug" ]; then
    flagsArray+=("--profile" "${cargoCheckType}")
  fi

  if [ -n "${cargoCheckNoDefaultFeatures-}" ]; then
    flagsArray+=("--no-default-features")
  fi

  if [ -n "${cargoCheckFeatures-}" ]; then
    flagsArray+=("--features=$(concatStringsSep "," cargoCheckFeatures)")
  fi

  prependToVar checkFlags --
  concatTo flagsArray cargoTestFlags checkFlags checkFlagsArray

  echoCmd 'cargoCCheckHook flags' "${flagsArray[@]}"
  @setEnv@ cargo ctest "${flagsArray[@]}"

  if [ -n "${buildAndTestSubdir-}" ]; then
    popd
  fi

  echo "Finished cargoCCheckHook"
}

if [ -z "${dontCargoCCheck-}"]; then
  postCheckHooks+=(cargoCCheckHook)
fi
