#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update

set -eou pipefail

version="$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --fail --location "https://api.github.com/repos/netbootxyz/netboot.xyz/releases/latest" | jq --raw-output .tag_name)"

nix-update --version "$version" --system x86_64-linux netbootxyz-efi
nix-update --version skip --system aarch64-linux netbootxyz-efi
