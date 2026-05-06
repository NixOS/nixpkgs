#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl_github() {
  curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

releaseInfo="$(curl_github \
  "https://api.github.com/repos/stashapp/stash/releases/latest")"

releaseTag="$(jq -r ".tag_name" <<< $releaseInfo)"
releaseDate="$(jq -r ".created_at" <<< $releaseInfo)"
tagInfo="$(curl_github \
  "https://api.github.com/repos/stashapp/stash/git/ref/tags/$releaseTag")"

appDate="$(date -d $releaseDate '+%Y-%m-%d %H:%M:%S')"
version="$(expr $releaseTag : 'v\(.*\)')"
gitHash="$(jq -r '.object.sha' <<< $tagInfo | cut -c-8)"

sed -E -i "s/(appDate = \").*\";/\1$appDate\";/" $SCRIPT_DIR/package.nix
sed -E -i "s/(gitHash = \").*\";/\1$gitHash\";/" $SCRIPT_DIR/package.nix

nix-update stash --version "$version"
