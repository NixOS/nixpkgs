declare composerRepository
declare version
declare composerNoDev
declare composerNoPlugins
declare composerNoScripts

preConfigureHooks+=(composerInstallConfigureHook)
preBuildHooks+=(composerInstallBuildHook)
preCheckHooks+=(composerInstallCheckHook)
preInstallHooks+=(composerInstallInstallHook)

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

    # Since this file cannot be generated in the composer-repository-hook.sh
    # because the file contains hardcoded nix store paths, we generate it here.
    composer-local-repo-plugin --no-ansi build-local-repo -m "${composerRepository}" .

    # Remove all the repositories of type "composer" and "vcs"
    # from the composer.json file.
    jq -r -c 'del(try .repositories[] | select(.type == "composer" or .type == "vcs"))' composer.json | sponge composer.json

    # Configure composer to disable packagist and avoid using the network.
    composer config repo.packagist false
    # Configure composer to use the local repository.
    composer config repo.composer composer file://"$PWD"/packages.json

    # Since the composer.json file has been modified in the previous step, the
    # composer.lock file needs to be updated.
    COMPOSER_ROOT_VERSION="${version}" \
    composer \
      --lock \
      --no-ansi \
      --no-install \
      --no-interaction \
      ${composerNoDev:+--no-dev} \
      ${composerNoPlugins:+--no-plugins} \
      ${composerNoScripts:+--no-scripts} \
      update

    echo "Finished composerInstallBuildHook"
}

composerInstallCheckHook() {
    echo "Executing composerInstallCheckHook"

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

    echo "Finished composerInstallCheckHook"
}

composerInstallInstallHook() {
    echo "Executing composerInstallInstallHook"

    # Finally, run `composer install` to install the dependencies and generate
    # the autoloader.
    # The COMPOSER_ROOT_VERSION environment variable is needed only for
    # vimeo/psalm.
    COMPOSER_ROOT_VERSION="${version}" \
    composer \
      --no-ansi \
      --no-interaction \
      ${composerNoDev:+--no-dev} \
      ${composerNoPlugins:+--no-plugins} \
      ${composerNoScripts:+--no-scripts} \
      install

    # Remove packages.json, we don't need it in the store.
    rm packages.json

    # Copy the relevant files only in the store.
    mkdir -p "$out"/share/php/"${pname}"
    cp -r . "$out"/share/php/"${pname}"/

    # Create symlinks for the binaries.
    jq -r -c 'try (.bin[] | select(test(".bat$")? | not) )' composer.json | while read -r bin; do
        mkdir -p "$out"/share/php/"${pname}" "$out"/bin
        makeWrapper "$out"/share/php/"${pname}"/"$bin" "$out"/bin/"$(basename "$bin")"
    done

    echo "Finished composerInstallInstallHook"
}
