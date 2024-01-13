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

composerRepositoryConfigureHook() {
    echo "Executing composerRepositoryConfigureHook"

    if [[ -e "$composerLock" ]]; then
        cp $composerLock composer.lock
    fi

    if [[ ! -f "composer.lock" ]]; then
        COMPOSER_ROOT_VERSION="${version}" \
        composer \
            --no-ansi \
            --no-install \
            --no-interaction \
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

    # Build the local composer repository
    # The command 'build-local-repo' is provided by the Composer plugin
    # nix-community/composer-local-repo-plugin.
    composer-local-repo-plugin --no-ansi build-local-repo ${composerNoDev:+--no-dev} -r repository

    echo "Finished composerRepositoryBuildHook"
}

composerRepositoryCheckHook() {
    echo "Executing composerRepositoryCheckHook"

    if ! composer validate --strict --no-ansi --no-interaction --quiet; then
        if [ ! -z "${composerStrictValidation-}" ]; then
            echo
            echo -e "\e[31mERROR: composer files validation failed\e[0m"
            echo
            echo -e '\e[31mThe validation of the composer.json and composer.lock failed.\e[0m'
            echo -e '\e[31mMake sure that the file composer.lock is consistent with composer.json.\e[0m'
            echo
            exit 1
        else
            echo
            echo -e "\e[33mWARNING: composer files validation failed\e[0m"
            echo
            echo -e '\e[33mThe validation of the composer.json and composer.lock failed.\e[0m'
            echo -e '\e[33mMake sure that the file composer.lock is consistent with composer.json.\e[0m'
            echo
            echo -e '\e[33mThis check is not blocking, but it is recommended to fix the issue.\e[0m'
            echo
        fi
    fi

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
