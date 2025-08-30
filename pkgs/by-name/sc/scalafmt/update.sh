#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq gnused nix

set -euo pipefail

latest_version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/scalameta/scalafmt/releases/latest | jq -r '.tag_name' | sed 's/^v//')

current_version=$(nix-instantiate --eval -A scalafmt.version | jq -r)

if [[ "$current_version" == "$latest_version" ]]; then
    echo "Already up to date, nothing to do."
    exit 0
fi

echo "Updating scalafmt: $current_version -> $latest_version"

package_dir="$(dirname "${BASH_SOURCE[0]}")"
package_nix="$package_dir/package.nix"

sed -i "s|version = \"$current_version\"|version = \"$latest_version\"|" "$package_nix"

build_output=$(nix-build -A scalafmt 2>&1) || true

if echo "$build_output" | grep -q "hash mismatch"; then
    new_deps_hash=$(echo "$build_output" | grep "got:" | sed -n 's/.*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*/\1/p' | head -1)
    if [[ -n "$new_deps_hash" ]]; then
        sed -i "s|outputHash = \"sha256-[A-Za-z0-9+/=]*\"|outputHash = \"$new_deps_hash\"|" "$package_nix"
    else
        echo "Could not extract new hash from build output, build output:"
        echo "$build_output"
        exit 1
    fi
else
    echo "Unexpected: Build succeeded without hash mismatch, build output:"
    echo "$build_output"
    exit 1
fi
