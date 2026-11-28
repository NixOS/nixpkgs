#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash curl jq nix-update cacert git
set -euo pipefail

new_version="$(curl -s "https://storage.eu-north1.nebius.cloud/cli/release/stable")"
nix-update nebius --version "$new_version"

