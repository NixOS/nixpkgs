declare composerLock
declare version
declare composerNoDev
declare composerNoPlugins
declare composerNoScripts
declare composerStrictValidation

preConfigureHooks+=(composerRepositoryConfigureHook)
preBuildHooks+=(composerRepositoryBuildHook)
preCheckHooks+=(composerRepositoryCheckHook)
preInstallHooks+=(composerRepositoryInstallHook)

source @phpScriptUtils@

composerRepositoryConfigureHook() {
    echo "Executing composerRepositoryConfigureHook"

    if [[ -e "$composerLock" ]]; then
        cp $composerLock composer.lock
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

    echo "Finished composerRepositoryConfigureHook"
}

composerRepositoryBuildHook() {
    echo "Executing composerRepositoryBuildHook"

    mkdir -p repository

    setComposeRootVersion

    # Build the local composer repository
    # The command 'build-local-repo' is provided by the Composer plugin
    # nix-community/composer-local-repo-plugin.
    composer-local-repo-plugin --no-ansi build-local-repo-lock ${composerNoDev:+--no-dev} -r repository

    echo "Finished composerRepositoryBuildHook"
}

composerRepositoryCheckHook() {
    echo "Executing composerRepositoryCheckHook"

    checkComposerValidate

    echo "Finished composerRepositoryCheckHook"
}

composerRepositoryInstallHook() {
    echo "Executing composerRepositoryInstallHook"

    mkdir -p $out

    cp -ar repository/. $out/

    # Copy the composer.lock files to the output directory, to be able to validate consistency with
    # the src composer.lock file where this fixed-output derivation is used
    cp composer.lock $out/

    echo "Finished composerRepositoryInstallHook"
}
