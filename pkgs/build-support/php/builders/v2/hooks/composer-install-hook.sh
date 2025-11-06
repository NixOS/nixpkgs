# shellcheck shell=bash

declare -g out
declare -g pname
declare -g composerVendor
declare -g -i composerStrictValidation="${composerStrictValidation:-0}"

declare -g composerNoDev
declare -g composerNoPlugins
declare -g composerNoScripts

declare -ga composerFlags=()
[[ -n "${composerNoDev-}" ]] && composerFlags+=(--no-dev)
[[ -n "${composerNoPlugins-}" ]] && composerFlags+=(--no-plugins)
[[ -n "${composerNoScripts-}" ]] && composerFlags+=(--no-scripts)

preConfigureHooks+=(composerInstallConfigureHook)
preBuildHooks+=(composerInstallBuildHook)
preCheckHooks+=(composerInstallCheckHook)
preInstallHooks+=(composerInstallInstallHook)

# shellcheck source=/dev/null
source @phpScriptUtils@

composerInstallConfigureHook() {
  echo "Executing composerInstallConfigureHook"

  setComposerRootVersion

  if [[ ! -e "${composerVendor}" ]]; then
    echo "No local composer vendor found." >&2
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

  echo "Finished composerInstallConfigureHook"
}

composerInstallBuildHook() {
  echo "Executing composerInstallBuildHook"

  setComposerEnvVariables

  echo -e "\e[32mInstalling Composer vendor in \"${COMPOSER_VENDOR_DIR}\" directory...\e[0m"
  cp -r "${composerVendor}"/${COMPOSER_VENDOR_DIR} .
  chmod -R +w ${COMPOSER_VENDOR_DIR}

  if [[ -f "composer.lock" ]]; then
    composer \
      "${composerFlags[@]}" \
      --no-interaction \
      --no-progress \
      --optimize-autoloader \
      install
  fi

  echo "Finished composerInstallBuildHook"
}

composerInstallCheckHook() {
  echo "Executing composerInstallCheckHook"

  checkComposerValidate

  echo "Finished composerInstallCheckHook"
}

composerInstallInstallHook() {
  echo "Executing composerInstallInstallHook"

  # Copy the relevant files only in the store.
  mkdir -p "$out"/share/php/"${pname}"
  cp -r . "$out"/share/php/"${pname}"/

  # Create symlinks for the binaries.
  mapfile -t BINS < <(jq -r -c 'try (.bin[] | select(test(".bat$")? | not) )' composer.json)
  for bin in "${BINS[@]}"; do
    echo -e "\e[32mCreating symlink ${bin}...\e[0m"
    mkdir -p "$out/bin"
    ln -s "$out/share/php/${pname}/${bin}" "$out/bin/$(basename "$bin")"
  done

  echo "Finished composerInstallInstallHook"
}
