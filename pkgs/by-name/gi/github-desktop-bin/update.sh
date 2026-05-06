#!/usr/bin/env nix-shell
#! nix-shell -I ../../../.. -i bash -p coreutils curl jq gnused

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

apiResponse=$(curl https://api.github.com/repos/desktop/desktop/releases/latest)

newVersion="$(jq -r .tag_name <<<"$apiResponse" | sed 's|^release-||')"

sed -i -e "/version =/ s|\".*\"|\"$newVersion\"|" package.nix

jq -f extract-assets.jq >sources.json <<<"$apiResponse"
