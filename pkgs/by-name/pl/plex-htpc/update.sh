#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq git gnused gnugrep


# executing this script without arguments will
# - find the newest stable plex-htpc version avaiable on snapcraft (https://snapcraft.io/plex-htpc)
# - read the current plex-htpc version from the current nix expression
# - update the nix expression if the versions differ
# - try to build the updated version, exit if that fails
# - give instructions for upstreaming

# As an optional argument you can specify the snapcraft channel to update to.
# Default is `stable` and only stable updates should be pushed to nixpkgs. For
# testing you may specify `candidate` or `edge`.


channel="${1:-stable}" # stable/candidate/edge
nixpkgs="$(git rev-parse --show-toplevel)"
plex_nix="$nixpkgs/pkgs/by-name/pl/plex-htpc/package.nix"


#
# find the newest stable plex-htpc version avaiable on snapcraft
#

# create bash array from snap info
snap_info=($(
  curl -s -H 'X-Ubuntu-Series: 16' \
    "https://api.snapcraft.io/api/v1/snaps/details/plex-htpc?channel=$channel" \
  | jq --raw-output \
    '.revision,.download_sha512,.version,.last_updated'
))

# "revision" is the actual version identifier on snapcraft, the "version" is
# just for human consumption. Revision is just an integer that gets increased
# by one every (stable or unstable) release.
revision="${snap_info[0]}"
# We need to escape the slashes
hash="$(nix-hash --to-sri --type sha512 ${snap_info[1]} | sed 's|/|\\/|g')"
upstream_version="${snap_info[2]}"
last_updated="${snap_info[3]}"
echo "Latest $channel release is $upstream_version from $last_updated."
#
# read the current plex-htpc version from the currently *committed* nix expression
#

current_version=$(
  grep 'version\s*=' "$plex_nix" \
  | sed -Ene 's/.*"(.*)".*/\1/p'
)

echo "Current version: $current_version"

#
# update the nix expression if the versions differ
#

if [[ "$current_version" == "$upstream_version" ]]; then
  echo "Plex is already up-to-date"
  exit 0
fi

echo "Updating from ${current_version} to ${upstream_version}, released on ${last_updated}"

# search-and-replace revision, hash and version
sed --regexp-extended \
  -e 's/rev\s*=\s*"[0-9]+"\s*;/rev = "'"${revision}"'";/' \
  -e 's/hash\s*=\s*"[^"]*"\s*;/hash = "'"${hash}"'";/' \
  -e 's/version\s*=\s*".*"\s*;/version = "'"${upstream_version}"'";/' \
  -i "$plex_nix"

