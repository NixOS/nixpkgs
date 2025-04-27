# shellcheck shell=bash
# This script is a hook that sets up a minimal git configuration

gitSetup () {
    @gitMinimal@ config --global user.name GitSetupHook
    @gitMinimal@ config --global user.email GitSetupHook@nixpkgs.invalid
}

postHooks+=(gitSetup)
