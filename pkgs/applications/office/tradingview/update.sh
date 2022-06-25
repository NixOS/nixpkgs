#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gnugrep jq

set -eu -o pipefail

dirname=$(dirname "$0" | xargs realpath)
nixpkgs=$(realpath "${dirname}/../../../..")
attr=tradingview
nix_file="$dirname/default.nix"

channel="${1:-stable}" # stable/candidate/edge

# create bash array from snap info
snap_info=($(
  curl -s -H 'X-Ubuntu-Series: 16' \
    "https://api.snapcraft.io/api/v1/snaps/details/tradingview?channel=$channel" \
  | jq --raw-output \
    '.revision,.download_sha512,.version,.last_updated'
))

# "revision" is the actual version identifier on snapcraft, the "version" is
# just for human consumption. Revision is just an integer that gets increased
# by one every (stable or unstable) release.
upstream_revision="${snap_info[0]}"
sha512="${snap_info[1]}"
upstream_version="${snap_info[2]}"
last_updated="${snap_info[3]}"
sri_hash=$(nix hash to-sri --type sha512 $sha512)

current_version=$(nix-instantiate --eval -E "with import $nixpkgs {}; $attr.version or (builtins.parseDrvName $attr.name).version" | tr -d '"')
current_revision=$(nix-instantiate --eval -E "with import $nixpkgs {}; $attr.revision or (builtins.parseDrvName $attr.name).revision" | tr -d '"')

if [ "$current_version" = "$upstream_version" ]; then
    if [ "$current_revision" = "$upstream_revision" ]; then
        echo "tradingview is up-to-date: ${current_version} (rev $current_revision)"
        exit 0
    fi
fi

echo "Updating to latest $channel: $upstream_version (rev $upstream_revision)"

# search-and-replace revision, hash and version
sed -E \
  -e 's|revision\s*=\s*"[0-9]+"\s*;|revision = "'"$upstream_revision"'";|' \
  -e 's|hash\s*=\s*"[^"]*"\s*;|hash = "'"$sri_hash"'";|' \
  -e 's|version\s*=\s*".*"\s*;|version = "'"$upstream_version"'";|' \
  -i "$nix_file"
