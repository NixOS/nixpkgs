#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix nix-prefetch-git coreutils curl jq gnused

set -e

# Will be replaced with the actual branch when running this from passthru.updateScript
BRANCH="@branch@"

if [[ ! "$(basename $PWD)" = "yuzu" ]]; then
    echo "error: Script must be ran from yuzu's directory!"
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

updateMainline() {
    OLD_MAINLINE_VERSION="$(getLocalVersion "yuzu-mainline")"
    OLD_MAINLINE_HASH="$(getLocalHash "yuzu-mainline")"

    NEW_MAINLINE_VERSION="$(curl -s ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
        "https://api.github.com/repos/yuzu-emu/yuzu-mainline/releases?per_page=1" | jq -r '.[0].name' | cut -d" " -f2)"

    if [[ "${OLD_MAINLINE_VERSION}" = "${NEW_MAINLINE_VERSION}" ]]; then
        echo "yuzu-mainline is already up to date!"

        [ "$KEEP_GOING" ] && return || exit
    else
        echo "yuzu-mainline: ${OLD_MAINLINE_VERSION} -> ${NEW_MAINLINE_VERSION}"
    fi

    echo "  Fetching source code..."

    NEW_MAINLINE_HASH="$(nix-prefetch-git --quiet --fetch-submodules --rev "mainline-0-${NEW_MAINLINE_VERSION}" "https://github.com/yuzu-emu/yuzu-mainline" | jq -r '.sha256')"

    echo "  Succesfully fetched. hash: ${NEW_MAINLINE_HASH}"

    sed -i "s/${OLD_MAINLINE_VERSION}/${NEW_MAINLINE_VERSION}/" ./default.nix
    sed -i "s/${OLD_MAINLINE_HASH}/${NEW_MAINLINE_HASH}/" ./default.nix
}

updateEarlyAccess() {
    OLD_EA_VERSION="$(getLocalVersion "yuzu-ea")"
    OLD_EA_HASH="$(getLocalHash "yuzu-ea")"

    NEW_EA_VERSION="$(curl -s ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
        "https://api.github.com/repos/pineappleEA/pineapple-src/releases?per_page=1" | jq -r '.[0].tag_name' | cut -d"-" -f2 | cut -d" " -f1)"

    if [[ "${OLD_EA_VERSION}" = "${NEW_EA_VERSION}" ]]; then
        echo "yuzu-ea is already up to date!"

        [ "$KEEP_GOING" ] && return || exit
    else
        echo "yuzu-ea: ${OLD_EA_VERSION} -> ${NEW_EA_VERSION}"
    fi

    echo "  Fetching source code..."

    NEW_EA_HASH="$(nix-prefetch-git --quiet --fetch-submodules --rev "EA-${NEW_EA_VERSION}" "https://github.com/pineappleEA/pineapple-src" | jq -r '.sha256')"

    echo "  Succesfully fetched. hash: ${NEW_EA_HASH}"

    sed -i "s/${OLD_EA_VERSION}/${NEW_EA_VERSION}/" ./default.nix
    sed -i "s/${OLD_EA_HASH}/${NEW_EA_HASH}/" ./default.nix
}

if [[ "$BRANCH" = "mainline" ]]; then
    updateMainline
elif [[ "$BRANCH" = "early-access" ]]; then
    updateEarlyAccess
else
    KEEP_GOING=1
    updateMainline
    updateEarlyAccess
fi
