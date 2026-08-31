#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl ripgrep

set -eu -o pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

# update-source-version and nix-instantiate expect to be at the root of nixpkgs
cd "$nixpkgs"

echo >&2 '=== Obtaining version data...'
version=$(curl -L https://benjamin.kuperberg.fr/chataigne/en | rg -o "selectFileToDownload\('win-x64-([0-9]+.[0-9]+.[0-9]+).exe'" -r '$1')
currentVersion=$(nix-instantiate --raw --eval --strict -A chataigne.version)

if [[ "$currentVersion" = "$version" ]]; then
    echo >&2 '=== No version change. Skipping!'
    exit 0
fi

echo >&2 '=== Updating package.nix ...'

# TODO: recommend this to zoom-us maintainer instead of prefetch and --system
doCross() {
    systemExample=${1?'Missing system example argument'}
    shift
    versionArg=${1?'Missing version argument'}
    shift

    echo >&2 "==== Updating system example $systemExample ..."
    update-source-version pkgsCross."$systemExample".chataigne "$versionArg" --ignore-same-version --print-changes
}

# First update version, then just hashes
doCross gnu64 "$version"
doCross aarch64-multiplatform ''
doCross raspberryPi ''
doCross x86_64-darwin ''
doCross aarch64-darwin ''
doCross mingwW64 ''

echo >&2 '=== Done!'
