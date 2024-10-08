declare composerVendor
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

    setComposerRootVersion

    if [[ ! -e "${composerVendor}" ]]; then
        echo "No local composer vendor found."
        exit 1
    fi

    install -Dm644 ${composerVendor}/composer.{json,lock} .

    if [[ ! -f "composer.lock" ]]; then
        composer \
            --no-install \
            --no-interaction \
            --no-progress \
            --optimize-autoloader \
            ${composerNoDev:+--no-dev} \
            ${composerNoPlugins:+--no-plugins} \
            ${composerNoScripts:+--no-scripts} \
            update

        install -Dm644 composer.lock -t $out/

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

    chmod +w composer.{json,lock}

    echo "Finished composerInstallConfigureHook"
}

composerInstallBuildHook() {
    echo "Executing composerInstallBuildHook"

    echo "Finished composerInstallBuildHook"
}

composerInstallCheckHook() {
    echo "Executing composerInstallCheckHook"

    checkComposerValidate

    echo "Finished composerInstallCheckHook"
}

composerInstallInstallHook() {
    echo "Executing composerInstallInstallHook"

    cp -ar ${composerVendor}/* .

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
