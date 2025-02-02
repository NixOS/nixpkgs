declare composerRepository
declare version
declare composerNoDev
declare composerNoPlugins
declare composerNoScripts

preConfigureHooks+=(composerInstallConfigureHook)
preBuildHooks+=(composerInstallBuildHook)
preCheckHooks+=(composerInstallCheckHook)
preInstallHooks+=(composerInstallInstallHook)

source @phpScriptUtils@

composerInstallConfigureHook() {
    echo "Executing composerInstallConfigureHook"

    if [[ ! -e "${composerRepository}" ]]; then
        echo "No local composer repository found."
        exit 1
    fi

    if [[ -e "$composerLock" ]]; then
        cp "$composerLock" composer.lock
    fi

    if [[ ! -f "composer.lock" ]]; then
        setComposeRootVersion

        composer \
            --no-install \
            --no-interaction \
            --no-progress \
            ${composerNoDev:+--no-dev} \
            ${composerNoPlugins:+--no-plugins} \
            ${composerNoScripts:+--no-scripts} \
            update

        mkdir -p $out
        cp composer.lock $out/

        echo
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
        echo

        exit 1
    fi

    echo "Validating consistency between composer.lock and ${composerRepository}/composer.lock"
    if ! @cmp@ -s "composer.lock" "${composerRepository}/composer.lock"; then
        echo
        echo -e "\e[31mERROR: vendorHash is out of date\e[0m"
        echo
        echo -e "\e[31mcomposer.lock is not the same in $composerRepository\e[0m"
        echo
        echo -e "\e[31mTo fix the issue:\e[0m"
        echo -e '\e[31m1. Set vendorHash to an empty string: `vendorHash = "";`\e[0m'
        echo -e '\e[31m2. Build the derivation and wait for it to fail with a hash mismatch\e[0m'
        echo -e '\e[31m3. Copy the "got: sha256-..." value back into the vendorHash field\e[0m'
        echo -e '\e[31m   You should have: vendorHash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";\e[0m'
        echo

        exit 1
    fi

    chmod +w composer.json composer.lock

    echo "Finished composerInstallConfigureHook"
}

composerInstallBuildHook() {
    echo "Executing composerInstallBuildHook"

    setComposeRootVersion

    # Since this file cannot be generated in the composer-repository-hook.sh
    # because the file contains hardcoded nix store paths, we generate it here.
    composer build-local-repo-lock -m "${composerRepository}" .

    echo "Finished composerInstallBuildHook"
}

composerInstallCheckHook() {
    echo "Executing composerInstallCheckHook"

    checkComposerValidate

    echo "Finished composerInstallCheckHook"
}

composerInstallInstallHook() {
    echo "Executing composerInstallInstallHook"

    setComposeRootVersion

    # Finally, run `composer install` to install the dependencies and generate
    # the autoloader.
    composer \
      --no-interaction \
      --no-progress \
      ${composerNoDev:+--no-dev} \
      ${composerNoPlugins:+--no-plugins} \
      ${composerNoScripts:+--no-scripts} \
      install

    # Copy the relevant files only in the store.
    mkdir -p "$out"/share/php/"${pname}"
    cp -r . "$out"/share/php/"${pname}"/

    # Create symlinks for the binaries.
    jq -r -c 'try (.bin[] | select(test(".bat$")? | not) )' composer.json | while read -r bin; do
        echo -e "\e[32mCreating symlink ${bin}...\e[0m"
        mkdir -p "$out"/bin
        ln -s "$out"/share/php/"${pname}"/"$bin" "$out"/bin/"$(basename "$bin")"
    done

    echo "Finished composerInstallInstallHook"
}
