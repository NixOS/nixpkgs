# shellcheck shell=bash
# This script is a hook that sets up a minimal git configuration

gitSetup () {
    echo "Setting up minimal git configuration..."
    GIT_CONFIG_GLOBAL=$(mktemp -t gitconfig.XXXXXX)
    export GIT_CONFIG_GLOBAL
    @gitMinimal@ config --global user.name GitSetupHook
    @gitMinimal@ config --global user.email GitSetupHook@nixpkgs.invalid
}

postHooks+=(gitSetup)
