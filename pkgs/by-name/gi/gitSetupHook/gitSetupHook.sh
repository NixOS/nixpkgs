# shellcheck shell=bash

gitSetup () {
    GIT_CONFIG_GLOBAL=$(mktemp -t gitconfig.XXXXXX)
    export GIT_CONFIG_GLOBAL
    @gitMinimal@ config --global user.name GitSetupHook
    @gitMinimal@ config --global user.email GitSetupHook@nixpkgs.invalid
}

postHooks+=(gitSetup)
