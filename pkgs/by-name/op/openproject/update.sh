#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bundix ruby_4_0 nixfmt

set -eu -o pipefail
set -x
dir="$(dirname "$(readlink -f "$0")")"

# nix-update-script already bumped src.tag/hash before this runs.
# Just regenerate the gem lockfiles for the current (already-updated) source.
repo=$(mktemp -d /tmp/openproject-update.XXX)
rm -f "$dir/gemset.nix" "$dir/Gemfile.lock"
openproject_storepath=$(nix build --no-link --print-out-paths -f . openproject.src)
cp -r --no-preserve=mode,ownership $openproject_storepath/. $repo/

# remove binary platform otherwise building will fail
BUNDLE_GEMFILE="$repo/Gemfile" bundler lock --remove-platform x86_64-linux --lockfile="$repo/Gemfile.lock"
BUNDLE_GEMFILE="$repo/Gemfile" bundler lock --remove-platform aarch64-linux --lockfile="$repo/Gemfile.lock"
BUNDLE_GEMFILE="$repo/Gemfile" bundler lock --add-platform ruby --lockfile="$repo/Gemfile.lock"

bundix --lock --lockfile="$repo/Gemfile.lock" --gemfile="$repo/Gemfile" --gemset="$dir/gemset.nix"

cp "$repo/Gemfile.lock" "$dir/"
nixfmt "$dir/gemset.nix"
