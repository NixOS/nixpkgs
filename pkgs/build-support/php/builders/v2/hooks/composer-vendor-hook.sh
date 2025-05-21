source @phpScriptUtils@

declare -g composerNoDev="${composerNoDev:+--no-dev}"
declare -g composerNoPlugins="${composerNoPlugins:+--no-plugins}"
declare -g composerNoScripts="${composerNoScripts:+--no-scripts}"

preConfigureHooks+=(composerVendorConfigureHook)
preBuildHooks+=(composerVendorBuildHook)
preCheckHooks+=(composerVendorCheckHook)
preInstallHooks+=(composerVendorInstallHook)

composerVendorConfigureHook() {
    echo "Executing composerVendorConfigureHook"

    setComposerRootVersion

    if [[ -f "composer.lock" ]]; then
        echo -e "\e[32mUsing \`composer.lock\` file from the source package\e[0m"
    fi

    if [[ -e "$composerLock" ]]; then
        echo -e "\e[32mUsing user provided \`composer.lock\` file from \`$composerLock\`\e[0m"
        install -Dm644 $composerLock ./composer.lock
    fi

    if [[ ! -f "composer.lock" ]]; then
        composer \
            --no-cache \
            --no-install \
            --no-interaction \
            --no-progress \
            --optimize-autoloader \
            ${composerNoDev} \
            ${composerNoPlugins} \
            ${composerNoScripts} \
            update

        if [[ -f "composer.lock" ]]; then
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
    fi

    if [[ -f "composer.lock" ]]; then
        chmod +w composer.lock
    fi

    chmod +w composer.json

    echo "Finished composerVendorConfigureHook"
}

composerVendorBuildHook() {
    echo "Executing composerVendorBuildHook"

    setComposerEnvVariables

    composer \
        --no-cache \
        --no-interaction \
        --no-progress \
        --optimize-autoloader \
        ${composerNoDev} \
        ${composerNoPlugins} \
        ${composerNoScripts} \
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

    cp -ar composer.json $(composer config vendor-dir) $out/
    mapfile -t installer_paths < <(jq -r -c 'try((.extra."installer-paths") | keys[])' composer.json)

    for installer_path in "${installer_paths[@]}"; do
        # Remove everything after {$name} placeholder
        installer_path="${installer_path/\{\$name\}*/}";
        out_installer_path="$out/${installer_path/\{\$name\}*/}";
        # Copy the installer path if it exists
        if [[ -d "$installer_path" ]]; then
            mkdir -p $(dirname "$out_installer_path")
            echo -e "\e[32mCopying installer path $installer_path to $out_installer_path\e[0m"
            cp -ar "$installer_path" "$out_installer_path"
            # Strip out the git repositories
            find $out_installer_path -name .git -type d -prune -print -exec rm -rf {} ";"
        fi
    done

    if [[ -f "composer.lock" ]]; then
        cp -ar composer.lock $out/
    fi

    echo "Finished composerVendorInstallHook"
}
