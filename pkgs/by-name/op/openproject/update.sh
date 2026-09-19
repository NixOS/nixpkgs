#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq bundix ruby_4_0 nix-update nixfmt openssl libyaml

# Dependencies openssl and libyaml are required during
# "bundle install"

set -eu -o pipefail
set -x
dir="$(dirname "$(readlink -f "$0")")"

current=$(nix --extra-experimental-features nix-command eval --raw -f . openproject.src.tag)
latest=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/opf/openproject/tags?per_page=1" | jq -r '.[0].name')

if [[ "$current" == "$latest" ]]; then
  echo "'openproject' is up-to-date ($current == $latest)"
  exit 0
fi

echo "Updating openproject to $latest"

repo=$(mktemp -d /tmp/openproject-update.XXX)

rm -f "$dir/gemset.nix" "$dir/Gemfile.lock"

openproject_storepath=$(nix --extra-experimental-features "nix-command flakes" flake prefetch github:opf/openproject/"$latest" --json | jq -r '.storePath')

cp -r --no-preserve=mode,ownership $openproject_storepath/. $repo/

BUNDLE_GEMFILE="$repo/Gemfile" bundler lock --remove-platform x86_64-linux --lockfile="$repo/Gemfile.lock"
BUNDLE_GEMFILE="$repo/Gemfile" bundler lock --remove-platform aarch64-linux --lockfile="$repo/Gemfile.lock"
# keep generic gems available for bundlerEnv consumers
BUNDLE_GEMFILE="$repo/Gemfile" bundler lock --add-platform ruby --lockfile="$repo/Gemfile.lock"
# generate gemset.nix
bundix --lock --lockfile="$repo/Gemfile.lock" --gemfile="$repo/Gemfile" --gemset="$dir/gemset.nix"

# update
cp "$repo/Gemfile.lock" "$dir/"
nix-update openproject --version "$latest"

nixfmt "$dir/gemset.nix"
