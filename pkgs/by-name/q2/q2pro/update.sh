#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git common-updater-scripts
set -euo pipefail

attr="q2pro"

tmpdir=$(mktemp -d "/tmp/$attr.XXX")
repo="$tmpdir/repo"
trap 'rm -rf $tmpdir' EXIT

git clone https://github.com/skullernet/q2pro.git "$repo"

rev="$(git -C "$repo" rev-parse HEAD)"
revCount="$(git -C "$repo" rev-list --count HEAD)"
sourceDate="$(git -C "$repo" show -s --format=%cd --date=format:'%Y-%m-%d' HEAD)"
sourceDateEpoch="$(git -C "$repo" show -s --format=%ct HEAD)"
version="0-unstable-$sourceDate"

echo "Updating q2pro to version $version (rev: $rev, date: $sourceDateEpoch)"

update-source-version "$attr" "$version" --rev="${rev}"
update-source-version "$attr" "$revCount" --ignore-same-hash --version-key=revCount
update-source-version "$attr" "$sourceDateEpoch" --ignore-same-hash --version-key=SOURCE_DATE_EPOCH
