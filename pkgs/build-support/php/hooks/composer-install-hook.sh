declare -a composerHomeDir
declare -a composerVendorCache
declare -a installComposerDevDependencies
declare -a runComposerScripts
declare -a runComposerPlugins
declare -a dontComposerInstallConfigureHook
declare -a dontComposerInstallBuildHook
declare -a dontComposerInstallInstallHook
declare -a version

if [[ -z "${dontComposerInstallConfigureHook-}" ]]; then
  preConfigureHooks+=(composerInstallConfigureHook)
fi

if [[ -z "${dontComposerInstallBuildHook-}" ]]; then
  preBuildHooks+=(composerInstallBuildHook)
fi

if [[ -z "${dontComposerInstallCheckHook-}" ]]; then
  preBuildHooks+=(composerInstallCheckHook)
fi

if [[ -z "${dontComposerInstallInstallHook-}" ]]; then
  preInstallHooks+=(composerInstallInstallHook)
fi

composerInstallConfigureHook() {
    echo "Executing composerInstallConfigureHook"

    if [[ ! -e "${composerRepository}" ]]; then
        echo "No local composer repository found."
        exit 1
    fi

    if [[ -e "$composerLock" ]]; then
        cp $composerLock composer.lock
        chmod +w composer.lock
    fi

    if [[ ! -f "composer.lock" ]]; then
        echo "No composer.lock file found"
        exit 1
    fi

    cp ${composerRepository}/composer.json .
    cp ${composerRepository}/composer.lock .

    echo "Finished composerInstallConfigureHook"
}

composerInstallBuildHook() {
    echo "Executing composerInstallBuildHook"

    composer --no-ansi build-local-repo -p ${composerRepository} > packages.json

    COMPOSER_ROOT_VERSION="${version}" \
    composer update --lock --no-ansi --no-install --no-plugins --no-scripts

    echo "Finished composerInstallBuildHook"
}

composerInstallCheckHook() {
    echo "Executing composerInstallCheckHook"

    argstr=("--no-interaction" "--no-ansi")

    composer check-platform-reqs "${argstr[@]}"
    composer validate "${argstr[@]}"

    echo "Finished composerInstallCheckHook"
}

composerInstallInstallHook() {
    echo "Executing composerInstallInstallHook"

    argstr=("--no-interaction" "--no-ansi")

    if [[ ! -n ${installComposerDevDependencies-} ]]; then
        argstr+=("--no-dev")
    fi

    if [[ ! -n ${runComposerScripts-} ]]; then
        argstr+=("--no-scripts")
    fi

    if [[ ! -n ${runComposerPlugins-} ]]; then
        argstr+=("--no-plugins")
    fi

    COMPOSER_ROOT_VERSION="${version}" \
    composer install "${argstr[@]}"

    rm packages.json
    mkdir -p $out/share/php/${pname}
    cp -r . $out/share/php/${pname}/

    jq -r -c 'try .bin[]' composer.json | while read bin; do
        mkdir -p $out/share/php/${pname} $out/bin
        ln -s $out/share/php/${pname}/$bin $out/bin/$(basename $bin)
    done

    echo "Finished composerInstallInstallHook"
}
