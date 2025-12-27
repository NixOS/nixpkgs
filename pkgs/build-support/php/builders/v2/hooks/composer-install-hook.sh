# shellcheck shell=bash

declare -g out
declare -g pname
declare -g composerVendor
declare -g -i composerStrictValidation="${composerStrictValidation:-0}"

declare -g composerNoDev
declare -g composerNoPlugins
declare -g composerNoScripts

declare -ga composerFlags=()

[[ 1 == "${composerNoDev:-1}" ]] && composerFlags+=(--no-dev)
[[ 1 == "${composerNoPlugins:-1}" ]] && composerFlags+=(--no-plugins)
[[ 1 == "${composerNoScripts:-1}" ]] && composerFlags+=(--no-scripts)

preConfigureHooks+=(composerInstallConfigureHook)
preBuildHooks+=(composerInstallBuildHook)
preCheckHooks+=(composerInstallCheckHook)
preInstallHooks+=(composerInstallInstallHook)

# shellcheck source=/dev/null
source @phpScriptUtils@

composerInstallConfigureHook() {
  echo "Running phase: composerInstallConfigureHook"

  setComposerRootVersion

  if [[ ! -e "${composerVendor}" ]]; then
    echo -e "\e[31mERROR: The 'composerVendor' attribute is missing or invalid.\e[0m" >&2
    exit 1
  fi

  install -Dm644 "${composerVendor}"/composer.json .

  if [[ -f "${composerVendor}/composer.lock" ]]; then
    install -Dm644 "${composerVendor}"/composer.lock .
  fi

  if [[ -f "composer.lock" ]]; then
    chmod +w composer.lock
  fi

  chmod +w composer.json

  echo "Finished phase: composerInstallConfigureHook"
}

composerInstallBuildHook() {
  echo "Running phase: composerInstallBuildHook"

  setComposerEnvVariables

  echo -e "\e[32mRestoring Composer vendor directory to '${COMPOSER_VENDOR_DIR}'...\e[0m"
  cp -r "${composerVendor}/${COMPOSER_VENDOR_DIR}" .
  chmod -R +w "${COMPOSER_VENDOR_DIR}"

  echo -e "\e[32mGenerating optimized autoloader and restoring 'bin' directory...\e[0m"
  COMPOSER_DISABLE_NETWORK=1 composer \
    "${composerFlags[@]}" \
    --no-interaction \
    --no-progress \
    --optimize-autoloader \
    install

  echo "Finished phase: composerInstallBuildHook"
}

composerInstallCheckHook() {
  echo "Running phase: composerInstallCheckHook"

  checkComposerValidate

  echo "Finished phase: composerInstallCheckHook"
}

composerInstallInstallHook() {
  echo "Running phase: composerInstallInstallHook"

  # Copy the relevant files only in the store.
  mkdir -p "$out"/share/php/"${pname}"
  cp -r . "$out"/share/php/"${pname}"/

  # Create symlinks for the binaries.
  mapfile -t BINS < <(jq -r -c 'try (.bin[] | select(test(".bat$")? | not) )' composer.json)
  for bin in "${BINS[@]}"; do
    echo -e "\e[32mInstalling binary: ${bin}\e[0m"
    mkdir -p "$out/bin"
    ln -s "$out/share/php/${pname}/${bin}" "$out/bin/$(basename "$bin")"
  done

  echo "Finished phase: composerInstallInstallHook"
}
