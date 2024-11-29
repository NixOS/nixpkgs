declare composerLock
declare version
declare composerNoDev
declare composerNoPlugins
declare composerNoScripts
declare composerStrictValidation

preConfigureHooks+=(composerVendorConfigureHook)
preBuildHooks+=(composerVendorBuildHook)
preCheckHooks+=(composerVendorCheckHook)
preInstallHooks+=(composerVendorInstallHook)

source @phpScriptUtils@

composerVendorConfigureHook() {
    echo "Executing composerVendorConfigureHook"

    setComposerRootVersion

    if [[ -e "$composerLock" ]]; then
        echo -e "\e[32mUsing user provided \`composer.lock\` file from \`$composerLock\`\e[0m"
        install -Dm644 $composerLock ./composer.lock
    fi

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

    echo "Finished composerVendorConfigureHook"
}

composerVendorBuildHook() {
    echo "Executing composerVendorBuildHook"

    setComposerEnvVariables

    composer \
        `# The acpu-autoloader is not reproducible and has to be disabled.` \
        `# Upstream PR: https://github.com/composer/composer/pull/12090` \
        `# --apcu-autoloader` \
        `# --apcu-autoloader-prefix="$(jq -r -c 'try ."content-hash"' < composer.lock)"` \
        --no-interaction \
        --no-progress \
        --optimize-autoloader \
        ${composerNoDev:+--no-dev} \
        ${composerNoPlugins:+--no-plugins} \
        ${composerNoScripts:+--no-scripts} \
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

    mkdir -p $out
    cp -ar composer.{json,lock} $(composer config vendor-dir) $out/

    echo "Finished composerVendorInstallHook"
}
