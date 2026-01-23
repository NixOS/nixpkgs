#! /usr/bin/env nix-shell
#! nix-shell -i bash --pure -p curl cacert jq

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
DRV_DIR="$PWD"

relinfo=$(curl -sL 'https://api.github.com/repos/keyboardio/chrysalis/releases' | jq 'map(select(.prerelease == false)) | max_by(.tag_name)')
newver=$(echo "$relinfo" | jq --raw-output '.tag_name' | sed 's|^v||')
hashurl=$(echo "$relinfo" | jq --raw-output '.assets[] | select(.name == "latest-linux.yml").browser_download_url')
newhash=$(curl -sL "$hashurl" | grep -Po '^sha512: \K.*')

sed -i package.nix \
    -e "/^  version =/ s|\".*\"|\"$newver\"|" \
    -e "/sha512-/ s|\".*\"|\"sha512-$newhash\"|" \
