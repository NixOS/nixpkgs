declare composerLock
declare version
declare composerNoDev
declare composerNoPlugins
declare composerNoScripts
declare composerStrictValidation

preConfigureHooks+=(composerWithPluginConfigureHook)
preBuildHooks+=(composerWithPluginBuildHook)
preCheckHooks+=(composerWithPluginCheckHook)
preInstallHooks+=(composerWithPluginInstallHook)
preInstallCheckHooks+=(composerWithPluginInstallCheckHook)

source @phpScriptUtils@

composerWithPluginConfigureHook() {
    echo "Executing composerWithPluginConfigureHook"

    mkdir -p $out

    export COMPOSER_HOME=$out

    if [[ -e "$composerLock" ]]; then
        cp $composerLock $out/composer.lock
    fi

    cp $composerJson $out/composer.json
    cp -ar $src $out/src

    if [[ ! -f "$out/composer.lock" ]]; then
        setComposeRootVersion

        composer \
            global \
            --no-install \
            --no-interaction \
            --no-progress \
            ${composerNoDev:+--no-dev} \
            ${composerNoPlugins:+--no-plugins} \
            ${composerNoScripts:+--no-scripts} \
            update

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

    echo "Finished composerWithPluginConfigureHook"
}

composerWithPluginBuildHook() {
    echo "Executing composerWithPluginBuildHook"

    echo "Finished composerWithPluginBuildHook"
}

composerWithPluginCheckHook() {
    echo "Executing composerWithPluginCheckHook"

    checkComposerValidate

    echo "Finished composerWithPluginCheckHook"
}

composerWithPluginInstallHook() {
    echo "Executing composerWithPluginInstallHook"

    composer \
        global \
        --no-interaction \
        --no-progress \
        ${composerNoDev:+--no-dev} \
        ${composerNoPlugins:+--no-plugins} \
        ${composerNoScripts:+--no-scripts} \
        install

    echo "Finished composerWithPluginInstallHook"
}

composerWithPluginInstallCheckHook() {
    composer global show $pluginName
}
