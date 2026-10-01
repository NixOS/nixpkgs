#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash curl jq nix-update cacert git
set -euo pipefail

new_version="$(curl https://accounts.magento.cloud/cli/manifest.json | jq --raw-output .[0].version)"
nix-update magento-cloud --version "$new_version"
