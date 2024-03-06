declare version
declare composerStrictValidation

setComposeRootVersion() {
    set +e # Disable exit on error

    if [[ -v version ]]; then
        echo -e "\e[32mSetting COMPOSER_ROOT_VERSION to $version\e[0m"
        export COMPOSER_ROOT_VERSION=$version
    fi

    set -e
}

checkComposerValidate() {
    if ! composer validate --strict --no-ansi --no-interaction --quiet --no-check-all --no-check-lock; then
        if [ "1" == "${composerStrictValidation-}" ]; then
            echo
            echo -e "\e[31mERROR: composer files validation failed\e[0m"
            echo
            echo -e '\e[31mThe validation of the composer.json failed.\e[0m'
            echo -e '\e[31mMake sure that the file composer.json is valid.\e[0m'
            echo
            exit 1
        else
            echo
            echo -e "\e[33mWARNING: composer files validation failed\e[0m"
            echo
            echo -e '\e[33mThe validation of the composer.json failed.\e[0m'
            echo -e '\e[33mMake sure that the file composer.json is valid.\e[0m'
            echo
            echo -e '\e[33mThis check is not blocking, but it is recommended to fix the issue.\e[0m'
            echo
        fi
    fi

    if ! composer validate --strict --no-ansi --no-interaction --quiet --no-check-all --check-lock; then
        if [ "1" == "${composerStrictValidation-}" ]; then
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
}
