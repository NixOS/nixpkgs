declare version

setComposeRootVersion() {
    set +e # Disable exit on error

    if [[ -v version ]]; then
        echo -e "\e[32mSetting COMPOSER_ROOT_VERSION to $version\e[0m"
        export COMPOSER_ROOT_VERSION=$version
    fi

    set -e
}
