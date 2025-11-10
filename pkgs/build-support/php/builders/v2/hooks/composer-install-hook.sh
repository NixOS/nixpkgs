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

  echo -e "\e[32mRestoring Composer cache ...\e[0m"
  mkdir -p .composer_cache_dir
  cp -r "${composerVendor}"/. .composer_cache_dir
  chmod -R +w .composer_cache_dir

  if [[ -f "composer.lock" ]]; then
    COMPOSER_CACHE_DIR=.composer_cache_dir composer \
      "${composerFlags[@]}" \
      --no-interaction \
      --no-progress \
      --optimize-autoloader \
      install
  fi

  rm -rf .composer_cache_dir

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
