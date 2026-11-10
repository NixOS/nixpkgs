#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl gnused jq xxd

# Update `elasticsearch8` and the Elasticsearch plugins to the latest 8.x release.
# The hashes come from the `.sha512` files that Elastic publishes.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
nixpkgs=$(git rev-parse --show-toplevel)
pkgFile=package.nix
pluginsFile=$nixpkgs/pkgs/servers/search/elasticsearch/plugins.nix

oldVersion=$(sed -n 's/^  version = "\(.*\)";$/\1/p' "$pkgFile")
newVersion=$(curl -sfL ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
  "https://api.github.com/repos/elastic/elasticsearch/releases?per_page=100" |
  jq -r '.[] | select(.prerelease | not) | .tag_name | ltrimstr("v") | select(startswith("8."))' |
  sort -V | tail -n1)

if [[ "$oldVersion" == "$newVersion" ]]; then
  echo "elasticsearch8 is up to date: $oldVersion"
  exit 0
fi

sri() {
  curl -sfL "$1.sha512" | cut -d' ' -f1 | xxd -r -p | base64 -w0 | sed 's/^/sha512-/'
}

replaceHash() {
  local file=$1 oldUrl=$2 newUrl=$3 old new
  old=$(sri "$oldUrl")
  new=$(sri "$newUrl")
  sed -i "s|$old|$new|" "$file"
}

base=https://artifacts.elastic.co/downloads/elasticsearch
for platform in linux-x86_64 linux-aarch64 darwin-aarch64; do
  replaceHash "$pkgFile" \
    "$base/elasticsearch-$oldVersion-$platform.tar.gz" \
    "$base/elasticsearch-$newVersion-$platform.tar.gz"
done

pluginBase=https://artifacts.elastic.co/downloads/elasticsearch-plugins
for plugin in analysis-icu analysis-kuromoji analysis-phonetic analysis-smartcn discovery-ec2; do
  replaceHash "$pluginsFile" \
    "$pluginBase/$plugin/$plugin-$oldVersion.zip" \
    "$pluginBase/$plugin/$plugin-$newVersion.zip"
done

sed -i "s|\"$oldVersion\"|\"$newVersion\"|" "$pkgFile" "$pluginsFile"
