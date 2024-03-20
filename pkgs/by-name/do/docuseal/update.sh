#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl bundix git ruby_3_2 pkg-config xmlstarlet nix-update

set -eu -o pipefail
dir="$(dirname "$(readlink -f "$0")")"

latest=$(curl https://github.com/docusealco/docuseal/tags.atom | xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m /atom:feed/atom:entry -v atom:title -n | head -n1)
latest="1.2.3"

if [[ "$(nix-instantiate -A docuseal.version --eval --json | jq -r)" = "$latest" ]];
then
  echo "Already using version $latest, skipping"
  exit 0
fi

echo "Updating docuseal to $latest"

repo=$(mktemp -d /tmp/docuseal-update.XXX)
rm -f "$dir"/gemset.nix "$dir"/Gemfile.lock "$dir"yarn.lock

git clone https://github.com/docusealco/docuseal.git --branch "$latest" "$repo"

bundix --lock --lockfile="$repo"/Gemfile.lock --gemfile="$repo"/Gemfile --gemset="$dir"/gemset.nix
yarnhash=$(nix hash file "$repo"/yarn.lock)
cp "$repo"/Gemfile.lock "$dir"/

nix-update docuseal --version "$latest"
sed -i -E -e "s#hash = \".*\"#hash = \"$yarnhash\"#" "$dir"/web.nix

rm -rf "$repo"
