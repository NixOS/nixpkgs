#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix-prefetch-github
#shellcheck shell=bash
set -euo pipefail

pkg_dir="$(dirname "$0")"
repo_root="$pkg_dir/../../../.."
jaspRev="$(nix-instantiate --eval --raw "$repo_root" -A jasp-desktop.src.rev)"
echo "Current jasp-desktop revision: $jaspRev" >&2

bundlesJsonPath="$(nix-build --no-out-link "$repo_root" -A jasp-desktop.src)/Modules/remote-bundles.json"
echo "Loading bundles from $bundlesJsonPath" >&2

# We just need to parse the pname and the tag from the filename
# so we don't care that we're using the entries of Windows-x86_64
jq -r '
  ."Windows-x86_64" | map(.url) | sort | .[] |
  split("jasp-stats-modules/")[1] | split("/") |
  [.[0], .[3]] | @tsv
' "$bundlesJsonPath" | while IFS=$'\t' read -r pname tag; do
  echo "Prefetching jasp-stats-modules/$pname at rev $tag" >&2
  prefetchData=$(nix-prefetch-github jasp-stats-modules "$pname" --rev "refs/tags/$tag")

  jq -c -n \
    --arg pname "$pname" \
    --arg tag "$tag" \
    --argjson prefetchData "$prefetchData" \
    '{
      key: $pname,
      value: {
        pname: $pname,
        version: $tag | split("_R-")[0],
        tag: $tag,
        hash: $prefetchData.hash
      }
    }'
done | jq -s 'from_entries' > "$pkg_dir/module-info.json"

echo "Successfully updated module-info.json" >&2
