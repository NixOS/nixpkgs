#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq

set -x -eu -o pipefail

NIXPKGS_PATH="$(git rev-parse --show-toplevel)"
DECK_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

OLD_VERSION="$(nix-instantiate --eval -E "with import $NIXPKGS_PATH {}; deck.version or (builtins.parseDrvName deck.name).version" | tr -d '"')"
LATEST_TAG=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} --silent https://api.github.com/repos/kong/deck/releases/latest | jq -r '.tag_name')
LATEST_VERSION=$(echo ${LATEST_TAG} | sed 's/^v//')

if [ ! "$OLD_VERSION" = "$LATEST_VERSION" ]; then
    SHA256=$(nix-prefetch-url --quiet --unpack https://github.com/kong/deck/archive/refs/tags/${LATEST_TAG}.tar.gz)
    NEW_HASH=$(curl -s https://api.github.com/repos/kong/deck/tags | jq -rc ".[] | select(.name==\"$LATEST_TAG\")|.commit.sha" | head -c 7 -)

    setKV () {
        sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" "${DECK_PATH}/default.nix"
    }


    setKV version ${LATEST_VERSION}
    setKV sha256 "${SHA256}"
    setKV short_hash "${NEW_HASH}"
    sed -i 's/vendorHash/vendorSha256/g' "${DECK_PATH}/default.nix"
    setKV vendorSha256 "0000000000000000000000000000000000000000000000000000" # The same as lib.fakeSha256

    set +e
    VENDOR_SHA256=$(nix-build --no-out-link -A deck $NIXPKGS_PATH 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g')
    set -e

    if [ -n "${VENDOR_SHA256:-}" ]; then
        sed -i 's/vendorSha256/vendorHash/g' "${DECK_PATH}/default.nix"
        setKV vendorHash ${VENDOR_SHA256}
    else
        echo "Update failed. VENDOR_SHA256 is empty."
        exit 1
    fi

else
    echo "deck is already up-to-date at $OLD_VERSION"
fi
