#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq internetarchive gnused gnugrep

nixpkgs="$(git rev-parse --show-toplevel)"
spotify_nix="$nixpkgs/pkgs/applications/audio/spotify/darwin.nix"

latest_version=$(
  ia list darwin-spotify-amd64 \
  | grep -Eo '^SpotifyAMD64-.*\.dmg$' \
  | sort -r | head -n1 \
  | sed -E 's/^SpotifyAMD64-([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\.[a-z0-9]+)\.dmg$/\1/'
)

current_version=$(
  grep 'version\s*=' "$spotify_nix" \
  | sed -Ene 's/.*"(.*)".*/\1/p'
)

if [[ $current_version == $latest_version ]]; then
  echo "Spotify is already up-to-date"
  exit 0
fi

echo "spotify: ${current_version} -> ${latest_version}"

hash_amd64="$(nix --extra-experimental-features nix-command store prefetch-file --json --hash-type sha256 "https://archive.org/download/darwin-spotify-amd64/SpotifyAMD64-${latest_version}.dmg" | jq -r '.hash')"
hash_arm64="$(nix --extra-experimental-features nix-command store prefetch-file --json --hash-type sha256 "https://archive.org/download/darwin-spotify-arm64/SpotifyARM64-${latest_version}.dmg" | jq -r '.hash')"

# search-and-replace revision, hash and version
sed --regexp-extended \
  -e '20s/sha256\s*=\s*"[^"]*"\s*;/sha256 = "'"${hash_arm64}"'";/' \
  -e '26s/sha256\s*=\s*"[^"]*"\s*;/sha256 = "'"${hash_amd64}"'";/' \
  -e 's/version\s*=\s*".*"\s*;/version = "'"${latest_version}"'";/' \
  -i "$spotify_nix"
