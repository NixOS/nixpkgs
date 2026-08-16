#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq git nix nix-prefetch-github

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/package.nix"

latest_rev=$(git ls-remote https://github.com/renode/renode refs/heads/master | awk '{print $1}')
commit_date=$(curl -s "https://api.github.com/repos/renode/renode/commits/${latest_rev}" | jq -r '.commit.committer.date' | cut -dT -f1)

latest_tag=$(curl -s https://api.github.com/repos/renode/renode/releases/latest | jq -r '.tag_name | ltrimstr("v")')

new_version="${latest_tag}-unstable-${commit_date}"

new_hash=$(nix-prefetch-github renode renode --rev "$latest_rev" --fetch-submodules | jq -r '.hash')

sed -i "s|version = \".*\"|version = \"${new_version}\"|" "$PKG_FILE"
sed -i "s|rev = \".*\"|rev = \"${latest_rev}\"|" "$PKG_FILE"
sed -i "s|hash = \".*\"|hash = \"${new_hash}\"|" "$PKG_FILE"

# Regenerate nuget deps in the correct location
$(nix-build -A renode-unstable.passthru.fetch-deps --no-out-link) "$SCRIPT_DIR/deps.json"
