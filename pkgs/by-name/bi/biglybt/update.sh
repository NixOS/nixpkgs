#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl_github() {
  curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

latestTag=$(curl_github https://api.github.com/repos/BiglySoftware/BiglyBT/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

echo "Updating biglybt"
nix-update --version "$latestVersion" \
--override-filename "$SCRIPT_DIR/package.nix" \
biglybt
