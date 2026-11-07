#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix-update jq
set -euo pipefail

new_version=$(curl -sSfL  https://packages.smallstep.com/stable/step-agent/index.json | jq -r '.latest_per_platform.linux')


nix-update step-agent --version "$new_version" --system x86_64-linux
nix-update step-agent --version skip --system aarch64-linux
