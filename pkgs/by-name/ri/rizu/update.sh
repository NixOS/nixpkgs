#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl unzip jq common-updater-scripts stylua

set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl -Lo "$tmpdir/rizu.zip" https://dl.rizu.su/rizu.zip
unzip -j "$tmpdir/rizu.zip" "*.love" -d "$tmpdir"
love_file=$(find "$tmpdir" -maxdepth 1 -name "*.love")
unzip "$love_file" version.lua sphere/persistence/ConfigModel/urls.lua -d "$tmpdir"

rev=$(sed -n 's/.*commit="\([^"]*\)".*/\1/p' "$tmpdir/version.lua")
old_rev=$(nix-instantiate --eval --expr '(import ./. { }).rizu.src.rev' | tr -d '"')
if [[ "$rev" == "$old_rev" ]]; then
  echo "Already up to date: $rev" >&2
  exit 0
fi

raw_date=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/semyon422/rizu/commits/$rev" | jq -r '.commit.committer.date')
version="0-unstable-$(echo "$raw_date" | cut -d'T' -f1)"

urls_path="$tmpdir/sphere/persistence/ConfigModel/urls.lua"
stylua --indent-type Spaces --indent-width 2 "$urls_path"
cp "$urls_path" "$(nix-instantiate --eval --expr 'toString (import ./. { }).rizu.passthru.urls' | tr -d '"')"

echo $version $rev >&2
update-source-version rizu "$version" --rev="$rev"
