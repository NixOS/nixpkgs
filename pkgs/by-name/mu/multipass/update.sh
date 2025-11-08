#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix-prefetch-github yj git
# shellcheck shell=bash

set -euo pipefail

cd $(readlink -e $(dirname "${BASH_SOURCE[0]}"))

# Download the latest pubspec.lock (which is a YAML file), convert it to JSON and write it to
# the package directory as pubspec.lock.json
update_pubspec_json() {
    local version; version="$1"
    echo "Updating pubspec.lock.json"

    curl -s \
        "https://raw.githubusercontent.com/canonical/multipass/refs/tags/v${version}/src/client/gui/pubspec.lock" \
        | yj > pubspec.lock.json
}

# Update the SRI hash of a particular overridden Dart package in the Nix expression
update_dart_pkg_hash() {
    local pkg_name; pkg_name="$1"
    local owner; owner="$2";
    local repo; repo="$3";
    echo "Updating dart package hash: $pkg_name"

    resolved_ref="$(jq -r --arg PKG "$pkg_name" '.packages[$PKG].description."resolved-ref"' pubspec.lock.json)"
    hash="$(nix-prefetch-github --rev "$resolved_ref" "$owner" "$repo" | jq '.hash')"
    sed -i "s|${pkg_name} = \".*\";|${pkg_name} = $hash;|" gui.nix
}

# Update the hash of the multipass source code in the Nix expression.
update_multipass_source() {
    local version; version="$1"
    echo "Updating multipass source"

    sri_hash="$(nix-prefetch-github canonical multipass --rev "refs/tags/v${version}" --fetch-submodules | jq -r '.hash')"

    sed -i "s|version = \".*$|version = \"$version\";|" package.nix
    sed -i "s|hash = \".*$|hash = \"${sri_hash}\";|" package.nix
}

LATEST_TAG="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/canonical/multipass/releases/latest | jq -r '.tag_name')"
LATEST_VERSION="$(expr "$LATEST_TAG" : 'v\(.*\)')"
CURRENT_VERSION="$(grep -Po "version = \"\K[^\"]+" package.nix)"

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo "multipass is up to date: ${CURRENT_VERSION}"
    exit 0
fi

update_pubspec_json "$LATEST_VERSION"

update_dart_pkg_hash dartssh2 canonical dartssh2
update_dart_pkg_hash hotkey_manager_linux canonical hotkey_manager
update_dart_pkg_hash tray_menu canonical tray_menu
update_dart_pkg_hash window_size google flutter-desktop-embedding
update_dart_pkg_hash xterm levkropp xterm.dart

update_multipass_source "$LATEST_VERSION"

