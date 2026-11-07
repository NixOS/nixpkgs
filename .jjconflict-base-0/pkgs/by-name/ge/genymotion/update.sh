#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update

set -euo pipefail

evalAttr() {
  nix-instantiate --eval --raw --attr "$1"
}

userAgent="Genymobile Genymotion $(evalAttr genymotion.version) - Linux nixos $(evalAttr stdenv.version)"
releaseInfo="$(curl -sL -A "$userAgent" https://cloud.genymotion.com/launchpad/last_version/linux/x64/)"
nix-update --version "$(echo "$releaseInfo" | jq -r .version)" genymotion
