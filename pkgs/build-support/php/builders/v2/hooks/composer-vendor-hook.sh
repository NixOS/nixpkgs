# shellcheck shell=bash

# shellcheck source=/dev/null
source @phpScriptUtils@

declare -g out
declare -g composerLock
declare -g composerNoDev
declare -g composerNoPlugins
declare -g composerNoScripts

declare -ga composerFlags=()

[[ -n "${composerNoDev-1}" ]] && composerFlags+=(--no-dev)
[[ -n "${composerNoPlugins-1}" ]] && composerFlags+=(--no-plugins)
[[ -n "${composerNoScripts-1}" ]] && composerFlags+=(--no-scripts)

preConfigureHooks+=(composerVendorConfigureHook)
preBuildHooks+=(composerVendorBuildHook)
preCheckHooks+=(composerVendorCheckHook)
preInstallHooks+=(composerVendorInstallHook)

composerVendorConfigureHook() {
  echo "Running phase: composerVendorConfigureHook"

  setComposerRootVersion

  if [[ -f "composer.lock" ]]; then
    echo -e "\e[32mFound 'composer.lock' in source root.\e[0m"
  fi

  if [[ -e "$composerLock" ]]; then
    echo -e "\e[32mUsing provided 'composer.lock' from: $composerLock\e[0m"
    install -Dm644 "$composerLock" ./composer.lock
  fi

  if [[ ! -f "composer.lock" ]]; then
    echo "No 'composer.lock' found. Updating dependencies to generate one..."
    composer \
      --no-cache \
      --no-install \
      --no-interaction \
      --no-progress \
      --optimize-autoloader \
      "${composerFlags[@]}" \
      update

    if [[ -f "composer.lock" ]]; then
      install -Dm644 composer.lock -t "$out"/

      echo
      echo -e "\e[31mERROR: Missing 'composer.lock' file.\e[0m"
      echo
      echo -e "\e[31mA 'composer.lock' file is required to ensure reproducible builds, but it was not found in the source.\e[0m"
      echo -e "\e[31mA temporary lock file has been generated for you at:\e[0m"
      echo -e "\e[31m  $out/composer.lock\e[0m"
      echo
      echo -e "\e[31mTo fix this issue:\e[0m"
      echo -e "\e[31m1. Copy the generated lock file to your project source:\e[0m"
      echo -e "\e[31m     cp $out/composer.lock <path/to/project_root>/\e[0m"
      echo -e "\e[31m2. Register the lock file in your Nix expression:\e[0m"
      echo -e "\e[31m     composerLock = ./composer.lock;\e[0m"
      echo

      exit 1
    fi
  fi

  if [[ -f "composer.lock" ]]; then
    chmod +w composer.lock
  fi

  chmod +w composer.json

  echo "Finished phase: composerVendorConfigureHook"
}

composerVendorBuildHook() {
  echo "Running phase: composerVendorBuildHook"

  setComposerEnvVariables

  echo -e "\e[32mInstalling Composer dependencies to '${COMPOSER_VENDOR_DIR}'...\e[0m"
  composer \
    --no-cache \
    --no-interaction \
    --no-progress \
    --no-autoloader \
    "${composerFlags[@]}" \
    install

  # Clarified: We remove it because we only want the 'vendor' folder here, not the bins yet.
  echo -e "\e[32mCleaning up Composer 'bin' directory (will be regenerated during install).\e[0m"
  rm -rf "$(composer config bin-dir)"

  echo "Finished phase: composerVendorBuildHook"
}

composerVendorCheckHook() {
  echo "Running phase: composerVendorCheckHook"

  checkComposerValidate

  echo "Finished phase: composerVendorCheckHook"
}

composerVendorInstallHook() {
  echo "Running phase: composerVendorInstallHook"

  mkdir -p "$out"

  echo -e "\e[32mPreserving Composer vendor directory from '${COMPOSER_VENDOR_DIR}'...\e[0m"
  cp -ar composer.json "${COMPOSER_VENDOR_DIR}" "$out"/
  mapfile -t installer_paths < <(jq -r -c 'try((.extra."installer-paths") | keys[])' composer.json)

  for installer_path in "${installer_paths[@]}"; do
    # Remove everything after {$name} placeholder
    installer_path="${installer_path/\{\$name\}*/}"
    out_installer_path="$out/${installer_path/\{\$name\}*/}"
    # Copy the installer path if it exists
    if [[ -d "$installer_path" ]]; then
      mkdir -p "$(dirname "$out_installer_path")"
      echo -e "\e[32mPreserving custom installer path: $installer_path\e[0m"
      cp -ar "$installer_path" "$out_installer_path"
      # Strip out the git repositories
      find "$out_installer_path" -name .git -type d -prune -print -exec rm -rf {} ";"
    fi
  done

  if [[ -f "composer.lock" ]]; then
    cp -ar composer.lock "$out"/
  fi

  echo "Finished phase: composerVendorInstallHook"
}
