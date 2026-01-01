# shellcheck shell=bash

# shellcheck source=/dev/null
source @phpScriptUtils@

declare -g out
declare -g composerLock
declare -g composerNoDev
declare -g composerNoPlugins
declare -g composerNoScripts

declare -ga composerFlags=()
<<<<<<< HEAD
[[ 1 == "${composerNoDev:-1}" ]] && composerFlags+=(--no-dev)
[[ 1 == "${composerNoPlugins:-1}" ]] && composerFlags+=(--no-plugins)
[[ 1 == "${composerNoScripts:-1}" ]] && composerFlags+=(--no-scripts)
=======
[[ -n "${composerNoDev-}" ]] && composerFlags+=(--no-dev)
[[ -n "${composerNoPlugins-}" ]] && composerFlags+=(--no-plugins)
[[ -n "${composerNoScripts-}" ]] && composerFlags+=(--no-scripts)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

preConfigureHooks+=(composerVendorConfigureHook)
preBuildHooks+=(composerVendorBuildHook)
preCheckHooks+=(composerVendorCheckHook)
preInstallHooks+=(composerVendorInstallHook)

composerVendorConfigureHook() {
<<<<<<< HEAD
  echo "Running phase: composerVendorConfigureHook"
=======
  echo "Executing composerVendorConfigureHook"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  setComposerRootVersion

  if [[ -f "composer.lock" ]]; then
<<<<<<< HEAD
    echo -e "\e[32mFound 'composer.lock' in source root.\e[0m"
  fi

  if [[ -e "$composerLock" ]]; then
    echo -e "\e[32mUsing provided 'composer.lock' from: $composerLock\e[0m"
=======
    echo -e "\e[32mUsing \`composer.lock\` file from the source package\e[0m"
  fi

  if [[ -e "$composerLock" ]]; then
    echo -e "\e[32mUsing user provided \`composer.lock\` file from \`$composerLock\`\e[0m"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    install -Dm644 "$composerLock" ./composer.lock
  fi

  if [[ ! -f "composer.lock" ]]; then
<<<<<<< HEAD
    echo "No 'composer.lock' found. Updating dependencies to generate one..."
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
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
=======
      echo -e "\e[31mERROR: No composer.lock found\e[0m"
      echo
      echo -e '\e[31mNo composer.lock file found, consider adding one to your repository to ensure reproducible builds.\e[0m'
      echo -e "\e[31mIn the meantime, a composer.lock file has been generated for you in $out/composer.lock\e[0m"
      echo
      echo -e '\e[31mTo fix the issue:\e[0m'
      echo -e "\e[31m1. Copy the composer.lock file from $out/composer.lock to the project's source:\e[0m"
      echo -e "\e[31m  cp $out/composer.lock <path>\e[0m"
      echo -e '\e[31m2. Add the composerLock attribute, pointing to the copied composer.lock file:\e[0m'
      echo -e '\e[31m  composerLock = ./composer.lock;\e[0m'
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      echo

      exit 1
    fi
  fi

  if [[ -f "composer.lock" ]]; then
    chmod +w composer.lock
  fi

  chmod +w composer.json

<<<<<<< HEAD
  echo "Finished phase: composerVendorConfigureHook"
}

composerVendorBuildHook() {
  echo "Running phase: composerVendorBuildHook"

  setComposerEnvVariables

  echo -e "\e[32mInstalling Composer dependencies to '${COMPOSER_VENDOR_DIR}'...\e[0m"
=======
  echo "Finished composerVendorConfigureHook"
}

composerVendorBuildHook() {
  echo "Executing composerVendorBuildHook"

  setComposerEnvVariables

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  composer \
    --no-cache \
    --no-interaction \
    --no-progress \
<<<<<<< HEAD
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
=======
    --optimize-autoloader \
    "${composerFlags[@]}" \
    install

  echo "Finished composerVendorBuildHook"
}

composerVendorCheckHook() {
  echo "Executing composerVendorCheckHook"

  checkComposerValidate

  echo "Finished composerVendorCheckHook"
}

composerVendorInstallHook() {
  echo "Executing composerVendorInstallHook"

  mkdir -p "$out"

  cp -ar composer.json "$(composer config vendor-dir)" "$out"/
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  mapfile -t installer_paths < <(jq -r -c 'try((.extra."installer-paths") | keys[])' composer.json)

  for installer_path in "${installer_paths[@]}"; do
    # Remove everything after {$name} placeholder
    installer_path="${installer_path/\{\$name\}*/}"
    out_installer_path="$out/${installer_path/\{\$name\}*/}"
    # Copy the installer path if it exists
    if [[ -d "$installer_path" ]]; then
      mkdir -p "$(dirname "$out_installer_path")"
<<<<<<< HEAD
      echo -e "\e[32mPreserving custom installer path: $installer_path\e[0m"
=======
      echo -e "\e[32mCopying installer path $installer_path to $out_installer_path\e[0m"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      cp -ar "$installer_path" "$out_installer_path"
      # Strip out the git repositories
      find "$out_installer_path" -name .git -type d -prune -print -exec rm -rf {} ";"
    fi
  done

  if [[ -f "composer.lock" ]]; then
    cp -ar composer.lock "$out"/
  fi

<<<<<<< HEAD
  echo "Finished phase: composerVendorInstallHook"
=======
  echo "Finished composerVendorInstallHook"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
