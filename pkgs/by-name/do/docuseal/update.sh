#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl bundix git ruby_3_3 prefetch-yarn-deps pkg-config xmlstarlet nix-update nixfmt-rfc-style

set -eu -o pipefail
dir="$(dirname "$(readlink -f "$0")")"

latest=$(curl https://github.com/docusealco/docuseal/tags.atom | xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m /atom:feed/atom:entry -v atom:title -n | head -n1)

if [[ "$(nix-instantiate -A docuseal.version --eval --json | jq -r)" = "$latest" ]];
then
  echo "Already using version $latest, skipping"
  exit 0
fi

echo "Updating docuseal to $latest"

repo=$(mktemp -d /tmp/docuseal-update.XXX)
rm -f "$dir/gemset.nix" "$dir/Gemfile" "$dir/Gemfile.lock" "$dir/yarn.lock"

git clone https://github.com/docusealco/docuseal.git --branch "$latest" "$repo"

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
YARN_HASH="$(nix hash to-sri --type sha256 "$YARN_HASH")"

# update
cp "$repo/Gemfile" "$repo/Gemfile.lock" "$repo/yarn.lock" "$dir/"
nix-update docuseal --version "$latest"
sed -i -E -e "s#hash = \".*\"#hash = \"$YARN_HASH\"#" "$dir"/web.nix

# fmt
nixfmt "$dir/"

rm -rf "$repo"
