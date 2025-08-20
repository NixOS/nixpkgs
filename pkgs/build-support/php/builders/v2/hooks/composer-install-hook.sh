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

    install -Dm644 ${composerVendor}/composer.json .

    if [[ -f "${composerVendor}/composer.lock" ]]; then
        install -Dm644 ${composerVendor}/composer.lock .
    fi

    if [[ -f "composer.lock" ]]; then
        chmod +w composer.lock
    fi

    chmod +w composer.json

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
