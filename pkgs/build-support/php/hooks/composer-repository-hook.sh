declare -a composerLock
declare -a composerOverrides
declare -a installComposerDevDependencies
declare -a runComposerScripts
declare -a runComposerPlugins
declare -a dontComposerRepositoryConfigureHook
declare -a dontComposerRepositoryBuildHook
declare -a dontComposerRepositoryInstallHook
declare -a version

if [[ -z "${dontComposerRepositoryConfigureHook-}" ]]; then
  postConfigureHooks+=(composerRepositoryConfigureHook)
fi

if [[ -z "${dontComposerRepositoryBuildHook-}" ]]; then
  preBuildHooks+=(composerRepositoryBuildHook)
fi

if [[ -z "${dontComposerRepositoryCheckHook-}" ]]; then
  preBuildHooks+=(composerRepositoryCheckHook)
fi

if [[ -z "${dontComposerRepositoryInstallHook-}" ]]; then
  preInstallHooks+=(composerRepositoryInstallHook)
fi

composerRepositoryConfigureHook() {
    echo "Executing composerRepositoryConfigureHook"

    if [[ -e "$composerLock" ]]; then
        cp $composerLock composer.lock
    fi

    if [[ ! -f "composer.lock" ]]; then
        echo "No composer.lock file found"
        exit 1
    fi

    # Controversial part: remove all dev dependencies
    # The development dependencies are superfluous for the actual building and
    # execution of the application. As Composer doesn't offer a mechanism to
    # selectively avoid downloading these dependencies, our viable solution is
    # to manually purge them from both the composer.lock and composer.json
    # files.
    jq '."packages-dev" = []' composer.lock | sponge composer.lock
    jq '."require-dev" = {}' composer.json | sponge composer.json

    # Configure composer to use the local repository
    composer config repo.packagist false
    composer config repo.composer '{"type": "composer", "url": "file://'"$PWD"'/packages.json"}'

    composer diagnose --no-ansi

    echo "Finished composerRepositoryConfigureHook"
}

composerRepositoryBuildHook() {
    echo "Executing composerRepositoryBuildHook"


    echo "Finished composerRepositoryBuildHook"
}

composerRepositoryCheckHook() {
    echo "Executing composerRepositoryCheckHook"

    echo "Finished composerRepositoryCheckHook"
}

composerRepositoryInstallHook() {
    echo "Executing composerRepositoryInstallHook"

    mkdir -p $out

    # Build the composer local repository
    composer --no-ansi build-local-repo -r $out

    cp -ar composer.lock composer.json $out/

    echo "Finished composerRepositoryInstallHook"
}
