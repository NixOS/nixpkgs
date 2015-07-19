#!/bin/sh

set -x

origin="$(pwd)"

# if setting KDE_MIRROR, be sure to set --cut-dirs=N in MANIFEST_EXTRA_ARGS
KDE_MIRROR="${KDE_MIRROR:-http://download.kde.org}"

alias nix-build="nix-build --no-out-link \"$origin/../../..\""

# The extra slash at the end of the URL is necessary to stop wget
# from recursing over the whole server! (No, it's not a bug.)
$(nix-build -A autonix.manifest) \
    "${KDE_MIRROR}/stable/applications/15.04.3/" \
    "$@" -A '*.tar.xz'

AUTONIX_DEPS_KF5=${AUTONIX_DEPS_KF5:-"$(nix-build -A haskellngPackages.autonix-deps-kf5)/bin/kf5-deps"}

$AUTONIX_DEPS_KF5 manifest.json

rm manifest.json
