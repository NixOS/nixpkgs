#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash
set -euo pipefail

version=$(curl -fsSL https://api.github.com/repos/inngest/inngest/releases/latest | jq -r '.tag_name | ltrimstr("v")')

cd "$(dirname "${BASH_SOURCE[0]}")/../../../.."

for system in \
  x86_64-linux \
  aarch64-linux \
  aarch64-darwin
do
  update-source-version inngest "$version" \
    --source-key="sources.$system" \
    --ignore-same-version \
    --ignore-same-hash
done
