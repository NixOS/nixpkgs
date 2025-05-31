#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl jq git gnused gnugrep libplist undmg
set -euo pipefail


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

update_linux() {
  nix_file="$nixpkgs/pkgs/by-name/sp/spotify/linux.nix"
  #
  # find the newest stable spotify version available on snapcraft
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
  # We need to escape the slashes
  hash="$(nix-hash --to-sri --type sha512 ${snap_info[1]} | sed 's|/|\\/|g')"
  upstream_version="${snap_info[2]}"
  last_updated="${snap_info[3]}"
  echo "Latest $channel release for Spotify on Linux is $upstream_version from $last_updated."
  #
  # read the current spotify version from the currently *committed* nix expression
  #

  current_nix_version=$(
    grep 'version\s*=' "$nix_file" \
    | sed -Ene 's/.*"(.*)".*/\1/p'
  )

  echo "Current Spotify for Linux version in Nixpkgs: $current_nix_version"

  #
  # update the nix expression if the versions differ
  #

  if [[ "$current_nix_version" = "$upstream_version" ]]; then
    echo "Spotify on Linux is already up-to-date"
    return
  fi

  echo "Updating Spotify on Linux from ${current_nix_version} to ${upstream_version}, released on ${last_updated}"

  # search-and-replace revision, hash and version
  sed --regexp-extended \
    -e 's/rev\s*=\s*"[0-9]+"\s*;/rev = "'"${revision}"'";/' \
    -e 's/hash\s*=\s*"[^"]*"\s*;/hash = "'"${hash}"'";/' \
    -e 's/version\s*=\s*".*"\s*;/version = "'"${upstream_version}"'";/' \
    -i "$nix_file"
}

update_macos() {
  nix_file="$nixpkgs/pkgs/by-name/sp/spotify/darwin.nix"

  tmp_dir=$(mktemp -d)
  trap 'rm -rf "$tmp_dir"' EXIT

  pushd $tmp_dir

  x86_64_url="https://download.scdn.co/Spotify.dmg"
  aarch64_url="https://download.scdn.co/SpotifyARM64.dmg"

  curl -OL $aarch64_url
  undmg SpotifyARM64.dmg
  upstream_version=$(plistutil -i Spotify.app/Contents/Info.plist -f json -o - | jq -r '.CFBundleVersion')

  popd

  current_nix_version=$(
    grep 'version\s*=' "$nix_file" \
    | sed -Ene 's/.*"(.*)".*/\1/p'
  )

  if [[ "$current_nix_version" != "$upstream_version" ]]; then
    archive_url="https://web.archive.org/save"
    archived_x86_64_url=$(curl -s -I -L -o /dev/null "$archive_url/$x86_64_url" -w '%{url_effective}')
    archived_aarch64_url=$(curl -s -I -L -o /dev/null "$archive_url/$aarch64_url" -w '%{url_effective}')

    update-source-version "pkgsCross.x86_64-darwin.spotify" "$upstream_version" "" "$archived_x86_64_url" \
      --file=$nix_file \
      --ignore-same-version

    update-source-version "pkgsCross.aarch64-darwin.spotify" "$upstream_version" "" "$archived_aarch64_url" \
      --file=$nix_file \
      --ignore-same-version
  fi
}

update_linux
update_macos
