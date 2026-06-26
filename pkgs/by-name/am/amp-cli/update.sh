#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

version=$(curl -fsSL https://static.ampcode.com/cli/cli-version.txt)

cd "$(dirname "${BASH_SOURCE[0]}")/../../../.."

for system in \
  x86_64-linux \
  aarch64-linux \
  x86_64-darwin \
  aarch64-darwin
do
  update-source-version amp-cli "$version" \
    --source-key="sources.$system" \
    --ignore-same-version \
    --ignore-same-hash
done
