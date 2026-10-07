#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq git prefetch-npm-deps moreutils common-updater-scripts

# shellcheck shell=bash

set -eou pipefail
set -x

NIXPKGS_DIR="$(git rev-parse --show-toplevel)"
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Get latest release
OPENGIST_RELEASE=$(
    curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        https://api.github.com/repos/thomiceli/opengist/releases/latest
)

# Get release information
latestVersion=$(echo "$OPENGIST_RELEASE" | jq -r ".tag_name")
latestVersion="${latestVersion:1}" # remove first char 'v'

oldVersion=$(nix eval --raw -f "$NIXPKGS_DIR" opengist.version)

if [[ "$oldVersion" == "$latestVersion" ]]; then
    echo "opengist is up-to-date: ${oldVersion}"
    exit 0
fi

echo "Updating opengist $oldVersion -> $latestVersion"

pushd "$NIXPKGS_DIR" >/dev/null || exit 1
update-source-version opengist "${latestVersion}"
popd >/dev/null

pushd "$SCRIPT_DIR" >/dev/null || exit 1

## npm hash
rm -f package{,-lock}.json
curl -sLO "https://raw.githubusercontent.com/thomiceli/opengist/refs/tags/v$latestVersion/package-lock.json"

npmDepsHash="$(prefetch-npm-deps package-lock.json)"
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' --in-place package.nix

popd >/dev/null

# nix-prefetch broken due to ninja finalAttrs.src.rev
# nix-update with goModules broken for this package

setKV() {
    sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" "${SCRIPT_DIR}/package.nix"
}

setKV vendorHash "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" # The same as lib.fakeHash

set +e
VENDOR_HASH=$(nix-build --no-out-link -A opengist "$NIXPKGS_DIR" 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g')
set -e

if [ -n "${VENDOR_HASH:-}" ]; then
    setKV vendorHash "${VENDOR_HASH}"
else
    echo "Update failed. VENDOR_HASH is empty."
    exit 1
fi
