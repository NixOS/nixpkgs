# shellcheck shell=bash disable=SC2154,SC2164

cargoDocBuildHook() {
  echo "Executing cargoDocBuildHook"

  if [[ -v buildAndTestSubdir ]]; then
    local targetDir
    targetDir="$(pwd)/target"
    pushd "$buildAndTestSubdir"
  fi

  @setEnv@ cargo doc \
    -j "$NIX_BUILD_CORES" \
    --target "@rustcTarget@" \
    --profile "$cargoBuildType" \
    --offline \
    --no-deps \
    ${targetDir+--target-dir "$targetDir"} \
    ${cargoBuildNoDefaultFeatures+--no-default-features} \
    ${cargoBuildFeatures+--features="$(concatStringsSep "," cargoBuildFeatures)"} \
    "${cargoDocFlags[@]}"

  if [[ -v buildAndTestSubdir ]]; then
    popd
  fi

  echo "Finished cargoDocBuildHook"
}

cargoDocInstallHook() {
  echo "Executing cargoDocInstallHook"

  # If no explicit outputRustdoc is specified, try devdoc and then out.
  if [[ ! -v outputRustdoc ]]; then
    for var in devdoc out; do
      if [[ -v "$var" ]]; then
        local outputRustdoc="$var"
        break
      fi
    done
  fi

  mkdir -p "${!outputRustdoc}/share"

  # Not installing into /share/doc as multiple-outputs.sh hook would move it
  # to doc output.
  cp -R -p -d "target/@targetSubdirectory@/doc" "${!outputRustdoc}/share/rustdoc"

  echo "Finished cargoDocInstallHook"
}

postBuildHooks+=(cargoDocBuildHook)
postInstallHooks+=(cargoDocInstallHook)
