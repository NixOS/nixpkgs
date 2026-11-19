#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../../../.."

version=$(
    curl --fail --silent https://repo1.maven.org/maven2/com/kohlschutter/junixsocket/junixsocket-common/maven-metadata.xml |
        grep -oP '<release>\K[^<]+'
)
update-source-version junixsocket-common "$version" --source-key=jar

for attr in junixsocket-native-common junixsocket-mysql; do
    file=$(nix-instantiate --eval --raw -A "$attr.meta.position")
    file=${file%:*}
    old_hash=$(nix-instantiate --eval --raw -A "$attr.jar.outputHash")
    url=$(nix-instantiate --eval --raw -E "builtins.head (import ./. { }).$attr.jar.urls")
    new_hash=$(nix-hash --type sha256 --to-sri "$(nix-prefetch-url --type sha256 "$url")")
    sed -i "s|\"$old_hash\"|\"$new_hash\"|" "$file"
done
