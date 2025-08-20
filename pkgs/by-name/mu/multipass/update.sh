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

# Update the version/hash of the grpc source code in the Nix expression.
update_grpc_source() {
    local version; version="$1"
    echo "Updating grpc source"

    submodule_info="https://raw.githubusercontent.com/canonical/multipass/refs/tags/v${version}/3rd-party/submodule_info.md"
    commit_short="$(curl -s "${submodule_info}" | grep -Po "CanonicalLtd/grpc/compare/v[0-9]+\.[0-9]+\.[0-9]+\.\.\K[0-9a-f]+")"
    commit_hash="$(curl -s "https://github.com/canonical/grpc/commits/${commit_short}" | grep -Po "${commit_short}[0-9a-f]+" | head -n1)"
    sri_hash="$(nix-prefetch-github canonical grpc --rev "${commit_hash}" --fetch-submodules | jq -r '.hash')"

    sed -i "s|rev = \".*$|rev = \"${commit_hash}\";|" multipassd.nix
    sed -i "s|hash = \".*$|hash = \"${sri_hash}\";|" multipassd.nix
}


LATEST_TAG="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/canonical/multipass/releases/latest | jq -r '.tag_name')"
LATEST_VERSION="$(expr "$LATEST_TAG" : 'v\(.*\)')"
CURRENT_VERSION="$(grep -Po "version = \"\K[^\"]+" package.nix)"

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo "multipass is up to date: ${CURRENT_VERSION}"
    exit 0
fi

update_pubspec_json "$LATEST_VERSION"

update_dart_pkg_hash dartssh2 andrei-toterman dartssh2
update_dart_pkg_hash hotkey_manager_linux andrei-toterman hotkey_manager
update_dart_pkg_hash system_info2 andrei-toterman system_info
update_dart_pkg_hash tray_menu andrei-toterman tray_menu
update_dart_pkg_hash window_size google flutter-desktop-embedding
update_dart_pkg_hash xterm levkropp xterm.dart

update_multipass_source "$LATEST_VERSION"

update_grpc_source "$LATEST_VERSION"
