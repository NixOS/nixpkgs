# shellcheck shell=bash

# Nix on Darwin does not bind-mount the build directory to /build like the
# Linux sandbox does, so $NIX_BUILD_TOP is a random path that rustc would embed
# in the panic locations and debug info of vendored dependencies, making the
# output irreproducible. Remap it to /build to match the Linux layout.
#
# NIX_RUSTFLAGS is consumed by the rustc wrapper and is used instead of
# RUSTFLAGS because the latter would make cargo ignore the
# `target.<triple>.rustflags` written to .cargo/config.toml by cargoSetupHook.
if [ -n "${NIX_BUILD_TOP-}" ]; then
    export NIX_RUSTFLAGS+=" --remap-path-prefix=$NIX_BUILD_TOP=/build"
fi
