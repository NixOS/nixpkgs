# shellcheck shell=bash

echo "Sourcing setuptools-rust-hook"

setuptoolsRustSetup() {
    # This can work only if rustPlatform.cargoSetupHook is also included
    if ! command -v cargoSetupPostPatchHook >/dev/null; then
        echo "ERROR: setuptools-rust has to be used alongside with rustPlatform.cargoSetupHook!"
        exit 1
    fi

    export PYO3_CROSS_LIB_DIR="@pyLibDir@"
    export CARGO_BUILD_TARGET=@cargoBuildTarget@
    # TODO theoretically setting linker should not be required because it is
    # already set in pkgs/build-support/rust/hooks/default.nix but build fails
    # on missing linker without this.
    export CARGO_TARGET_@cargoLinkerVar@_LINKER=@targetLinker@
}

preConfigureHooks+=(setuptoolsRustSetup)
