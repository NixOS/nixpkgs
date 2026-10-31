#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

# releases/latest skips the -beta prereleases that upstream also publishes.
version=$(curl -fsSL https://api.github.com/repos/steipete/CodexBar/releases/latest \
  | jq -r '.tag_name | ltrimstr("v")')

cd "$(dirname "${BASH_SOURCE[0]}")/../../../.."

for system in \
  x86_64-linux \
  aarch64-linux \
  x86_64-darwin \
  aarch64-darwin
do
  update-source-version codexbar-cli "$version" \
    --source-key="sources.$system" \
    --ignore-same-version \
    --ignore-same-hash
done
