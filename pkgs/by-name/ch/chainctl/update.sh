#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

VERSION="$(curl -fsSL https://dl.enforce.dev/chainctl/latest/metadata.json | jq -r .version)"
echo "chainctl: latest upstream version is $VERSION"

# --ignore-same-version: after the first iteration the version is already
# current; subsequent calls only need to refresh the per-platform hash.
for platform in \
  x86_64-linux \
  aarch64-linux \
  x86_64-darwin \
  aarch64-darwin; do
  echo "chainctl: updating $platform"
  update-source-version chainctl "$VERSION" \
    --source-key="sources.${platform}" \
    --ignore-same-version
done

echo "chainctl: done"
