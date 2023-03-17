#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq git gnused gnugrep


# executing this script without arguments will
# - find the newest stable spotify version avaiable on snapcraft (https://snapcraft.io/spotify)
# - read the current spotify version from the current nix expression
# - update the nix expression if the versions differ
# - try to build the updated version, exit if that fails
# - give instructions for upstreaming

# Please test the update manually before pushing. There have been errors before
# and because the service is proprietary and a paid account is necessary to do
# anything with spotify automatic testing is not possible.

# As an optional argument you can specify the snapcraft channel to update to.
# Default is `stable` and only stable updates should be pushed to nixpkgs. For
# testing you may specify `candidate` or `edge`.


channel="${1:-stable}" # stable/candidate/edge
nixpkgs="$(git rev-parse --show-toplevel)"
spotify_nix="$nixpkgs/pkgs/applications/audio/spotify/default.nix"


#
# find the newest stable spotify version avaiable on snapcraft
#

# create bash array from snap info
snap_info=($(
  curl -s -H 'X-Ubuntu-Series: 16' \
    "https://api.snapcraft.io/api/v1/snaps/details/spotify?channel=$channel" \
  | jq --raw-output \
    '.revision,.download_sha512,.version,.last_updated'
))

# "revision" is the actual version identifier on snapcraft, the "version" is
# just for human consumption. Revision is just an integer that gets increased
# by one every (stable or unstable) release.
revision="${snap_info[0]}"
sha512="${snap_info[1]}"
upstream_version="${snap_info[2]}"
last_updated="${snap_info[3]}"

echo "Latest $channel release is $upstream_version from $last_updated."

#
# read the current spotify version from the currently *committed* nix expression
#

current_nix_version=$(
  grep 'version\s*=' "$spotify_nix" \
  | sed -Ene 's/.*"(.*)".*/\1/p'
)

echo "Current nix version: $current_nix_version"

#
# update the nix expression if the versions differ
#

if [[ "$current_nix_version" = "$upstream_version" ]]; then
  echo "Spotify is already up-to-date"
  exit 0
fi

echo "Updating from ${current_nix_version} to ${upstream_version}, released on ${last_updated}"

# search-and-replace revision, hash and version
sed --regexp-extended \
  -e 's/rev\s*=\s*"[0-9]+"\s*;/rev = "'"${revision}"'";/' \
  -e 's/sha512\s*=\s*"[^"]*"\s*;/sha512 = "'"${sha512}"'";/' \
  -e 's/version\s*=\s*".*"\s*;/version = "'"${upstream_version}"'";/' \
  -i "$spotify_nix"

#
# try to build the updated version
#

if ! nix-build -A spotify "$nixpkgs"; then
  echo "The updated spotify failed to build."
  exit 1
fi

# Commit changes
git add "$spotify_nix"
git commit -m "spotify: ${current_nix_version} -> ${upstream_version}"
