#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq

set -x -eu -o pipefail

NIXPKGS_PATH="$(git rev-parse --show-toplevel)"
CMCTL_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

OLD_VERSION="$(nix-instantiate --eval -E "with import $NIXPKGS_PATH {}; cmctl.version or (builtins.parseDrvName cmctl.name).version" | tr -d '"')"
LATEST_TAG="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/cert-manager/cert-manager/releases" | jq '.[].tag_name' --raw-output | sed '/-/d' | sort --version-sort -r | head -n 1)"
LATEST_VERSION="${LATEST_TAG:1}"

if [ ! "$OLD_VERSION" = "$LATEST_VERSION" ]; then
    SHA256=$(nix-prefetch-url --quiet --unpack https://github.com/cert-manager/cert-manager/archive/refs/tags/${LATEST_TAG}.tar.gz)
    TAG_SHA=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"}  "https://api.github.com/repos/cert-manager/cert-manager/git/ref/tags/${LATEST_TAG}" | jq -r '.object.sha')
    TAG_COMMIT_SHA=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/cert-manager/cert-manager/git/tags/${TAG_SHA}" | jq '.object.sha' --raw-output)

    setKV () {
        sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" "${CMCTL_PATH}/default.nix"
    }

    setKV version ${LATEST_VERSION}
    setKV sha256 "${SHA256}"
    setKV rev ${TAG_COMMIT_SHA}
    setKV vendorSha256 "0000000000000000000000000000000000000000000000000000" # The same as lib.fakeSha256

    set +e
    VENDOR_SHA256=$(nix-build --no-out-link -A cmctl $NIXPKGS_PATH 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g')
    set -e

    if [ -n "${VENDOR_SHA256:-}" ]; then
        setKV vendorSha256 ${VENDOR_SHA256}
    else
        echo "Update failed. VENDOR_SHA256 is empty."
        exit 1
    fi

    echo "updated cmctl to $LATEST_VERSION, please commit changes."
else
    echo "cmctl is already up-to-date at $OLD_VERSION"
fi
