#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bundler bundix curl jq common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

main() {
    local currentVer="$1"
    local scriptDir="$2"
    local latestVer
    local srcDir

    if [[ -z "$UPDATE_NIX_ATTR_PATH" ]]; then
        echo "[ERROR] Please run the following instead:" >&2
        echo >&2
        echo "    % nix-shell maintainers/scripts/update.nix --argstr path mikutter" >&2
        exit 1
    fi

    latestVer="$(queryLatestVersion)"
    if [[ "$currentVer" == "$latestVer" ]]; then
        echo "[INFO] mikutter is already up to date" >&2
        exit
    fi

    update-source-version "$UPDATE_NIX_ATTR_PATH" "$latestVer"

    cd "$scriptDir"

    rm -rf deps
    mkdir deps
    cd deps

    srcDir="$(nix-build ../../../../../.. --no-out-link -A mikutter.src)"
    tar xvf "$srcDir" --strip-components=1
    find . -not -name Gemfile -exec rm {} \;
    find . -type d -exec rmdir -p --ignore-fail-on-non-empty {} \; || true

    bundle lock
    bundix
}

queryLatestVersion() {
    curl -sS 'https://mikutter.hachune.net/download.json?count=1' \
        | jq -r '.[].version_string' \
        | head -n1
}

main "$@"

# vim:set ft=bash:
