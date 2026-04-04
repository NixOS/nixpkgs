#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix-update

set -euo pipefail

current_version=$(nix-instantiate --eval -E "with import ./. {}; cef-binary.version or (lib.getVersion cef-binary)" | tr -d '"')

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

version_json=$(curl --silent https://cef-builds.spotifycdn.com/index.json | jq '[.linux64.versions[] | select (.channel == "stable")][0]')
cef_version=$(echo "$version_json" | jq -r '.cef_version' | cut -d'+' -f1)
git_revision=$(echo "$version_json" | jq -r '.cef_version' | cut -d'+' -f2 | cut -c 2-)
chromium_version=$(echo "$version_json" | jq -r '.chromium_version')

echo "Latest  version: $cef_version"
echo "Current version: $current_version"

if [[ "$cef_version" == "$current_version" ]]; then
    echo "Package is up-to-date"
    exit 0
fi

update_nix_value() {
    local key="$1"
    local value="${2:-}"
    sed -i "s|$key ? \".*\"|$key ? \"$value\"|" $ROOT/package.nix
}

update_nix_value version "$cef_version"
update_nix_value gitRevision "$git_revision"
update_nix_value chromiumVersion "$chromium_version"

nix-update pkgsCross.gnu64.cef-binary --version skip
nix-update pkgsCross.aarch64-multiplatform.cef-binary --version skip
