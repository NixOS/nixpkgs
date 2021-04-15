#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -I nixpkgs=../../../../.. -p bundler bundix curl jq common-updater-scripts
# shellcheck shell=bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
    local latestVer
    local srcDir

    if [[ -z "$UPDATE_NIX_ATTR_PATH" ]]; then
        echo "[ERROR] Please run the following instead:" >&2
        echo >&2
        echo "    % nix-shell maintainers/scripts/update.nix --argstr path mikutter" >&2
        exit 1
    fi

    latestVer="$(queryLatestVersion)"
    update-source-version "$UPDATE_NIX_ATTR_PATH" "$latestVer"

    cd "$SCRIPT_DIR"

    rm -rf deps
    mkdir deps
    cd deps

    srcDir="$(nix-build ../../../../.. --no-out-link -A mikutter.src)"
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
