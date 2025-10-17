#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq bundix ruby_3_4 prefetch-yarn-deps nix-update nixfmt

set -eu -o pipefail
dir="$(dirname "$(readlink -f "$0")")"

current=$(nix --extra-experimental-features nix-command eval --raw -f . docuseal.src.tag)
latest=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/docusealco/docuseal/tags?per_page=1" | jq -r '.[0].name')

if [[ "$current" == "$latest" ]]; then
  echo "'docuseal' is up-to-date ($current == $latest)"
  exit 0
fi

echo "Updating docuseal to $latest"

repo=$(mktemp -d /tmp/docuseal-update.XXX)

rm -f "$dir/gemset.nix" "$dir/Gemfile" "$dir/Gemfile.lock" "$dir/yarn.lock"

docuseal_storepath=$(nix --extra-experimental-features "nix-command flakes" flake prefetch github:docusealco/docuseal/"$latest" --json | jq -r '.storePath')

cp -r  --no-preserve=mode,ownership $docuseal_storepath/* $repo/

# patch ruby version
sed -i "/^ruby '[0-9]\+\.[0-9]\+\.[0-9]\+'$/d" "$repo/Gemfile"

# fix: https://github.com/nix-community/bundix/issues/88
BUNDLE_GEMFILE="$repo/Gemfile" bundler lock --remove-platform x86_64-linux --lockfile="$repo/Gemfile.lock"
BUNDLE_GEMFILE="$repo/Gemfile" bundler lock --remove-platform aarch64-linux --lockfile="$repo/Gemfile.lock"
# generate gemset.nix
bundix --lock --lockfile="$repo/Gemfile.lock" --gemfile="$repo/Gemfile" --gemset="$dir/gemset.nix"

# patch yarn.lock
sed -i 's$, "@hotwired/turbo@https://github.com/docusealco/turbo#main"$$g' "$repo/yarn.lock"

# calc yarn hash
YARN_HASH="$(prefetch-yarn-deps "$repo/yarn.lock")"
YARN_HASH="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$YARN_HASH")"

# update
cp "$repo/Gemfile" "$repo/Gemfile.lock" "$repo/yarn.lock" "$dir/"
nix-update docuseal --version "$latest"
nix-update docuseal --subpackage "docusealWeb"

nixfmt "$dir/gemset.nix"
