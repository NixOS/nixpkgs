#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bundix ruby_3_3 nixfmt
set -eu -o pipefail
set -x
dir="$(dirname "$(readlink -f "$0")")"

# nix-update-script already bumped src.tag/hash before this runs.
# Just regenerate the gem lockfiles for the current (already-updated) source.
repo=$(mktemp -d /tmp/greenlight-update.XXX)
rm -f "$dir/gemset.nix" "$dir/Gemfile.lock"
greenlight_storepath=$(nix build --no-link --print-out-paths -f . greenlight.src)
cp -r --no-preserve=mode,ownership "$greenlight_storepath/." "$repo/"

# remove binary platform otherwise building will fail
# see https://github.com/bigbluebutton/greenlight/pull/6317
BUNDLE_GEMFILE="$repo/Gemfile" bundler lock --remove-platform x86_64-linux --lockfile="$repo/Gemfile.lock"
bundix --lock --lockfile="$repo/Gemfile.lock" --gemfile="$repo/Gemfile" --gemset="$dir/gemset.nix"

cp "$repo/Gemfile.lock" "$dir/"
nixfmt "$dir/gemset.nix"
