#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix nix-prefetch-git coreutils curl jq gnused

set -euo pipefail

# Will be replaced with the actual branch when running this from passthru.updateScript
BRANCH="@branch@"

if [[ ! "$(basename $PWD)" = "citra" ]]; then
    echo "error: Script must be ran from citra's directory!"
    exit 1
fi

getLocalVersion() {
    pushd ../../../.. >/dev/null
    nix eval --raw -f default.nix "$1".version
    popd >/dev/null
}

getLocalHash() {
    pushd ../../../.. >/dev/null
    nix eval --raw -f default.nix "$1".src.drvAttrs.outputHash
    popd >/dev/null
}

updateNightly() {
    OLD_NIGHTLY_VERSION="$(getLocalVersion "citra-nightly")"
    OLD_NIGHTLY_HASH="$(getLocalHash "citra-nightly")"

    NEW_NIGHTLY_VERSION="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        "https://api.github.com/repos/citra-emu/citra-nightly/releases?per_page=1" | jq -r '.[0].name' | cut -d"-" -f2 | cut -d" " -f2)"

    if [[ "${OLD_NIGHTLY_VERSION}" = "${NEW_NIGHTLY_VERSION}" ]]; then
        echo "citra-nightly is already up to date!"

        [ "$KEEP_GOING" ] && return || exit
    else
        echo "citra-nightly: ${OLD_NIGHTLY_VERSION} -> ${NEW_NIGHTLY_VERSION}"
    fi

    echo "  Fetching source code..."

    NEW_NIGHTLY_HASH="$(nix-prefetch-git --quiet --fetch-submodules --rev "nightly-${NEW_NIGHTLY_VERSION}" "https://github.com/citra-emu/citra-nightly" | jq -r '.sha256')"

    echo "  Successfully fetched. hash: ${NEW_NIGHTLY_HASH}"

    sed -i "s|${OLD_NIGHTLY_VERSION}|${NEW_NIGHTLY_VERSION}|" ./default.nix
    sed -i "s|${OLD_NIGHTLY_HASH}|${NEW_NIGHTLY_HASH}|" ./default.nix
}

updateCanary() {
    OLD_CANARY_VERSION="$(getLocalVersion "citra-canary")"
    OLD_CANARY_HASH="$(getLocalHash "citra-canary")"

    NEW_CANARY_VERSION="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        "https://api.github.com/repos/citra-emu/citra-canary/releases?per_page=1" | jq -r '.[0].name' | cut -d"-" -f2 | cut -d" " -f1)"

    if [[ "${OLD_CANARY_VERSION}" = "${NEW_CANARY_VERSION}" ]]; then
        echo "citra-canary is already up to date!"

        [ "$KEEP_GOING" ] && return || exit
    else
        echo "citra-canary: ${OLD_CANARY_VERSION} -> ${NEW_CANARY_VERSION}"
    fi

    echo "  Fetching source code..."

    NEW_CANARY_HASH="$(nix-prefetch-git --quiet --fetch-submodules --rev "canary-${NEW_CANARY_VERSION}" "https://github.com/citra-emu/citra-canary" | jq -r '.sha256')"

    echo "  Successfully fetched. hash: ${NEW_CANARY_HASH}"

    sed -i "s|${OLD_CANARY_VERSION}|${NEW_CANARY_VERSION}|" ./default.nix
    sed -i "s|${OLD_CANARY_HASH}|${NEW_CANARY_HASH}|" ./default.nix
}

if [[ "$BRANCH" = "nightly" ]]; then
    updateNightly
elif [[ "$BRANCH" = "early-access" ]]; then
    updateCanary
else
    KEEP_GOING=1
    updateNightly
    updateCanary
fi
