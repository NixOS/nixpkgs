#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gawk gnused jq nix nix-update

set -euo pipefail

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

nix-update riptide "$@"

version=$(nix-instantiate --eval -E "with import ./. {}; riptide.version" | tr -d '"')

# The cef crate's version is the crate's own, then the CEF build it binds: 154.5.0+154.0.34.
lock=$(curl -fsSL "https://raw.githubusercontent.com/joshzcold/riptide/v$version/Cargo.lock")
crate=$(awk '/^name = "cef"$/ { getline; gsub(/version = |"/, ""); print; exit }' <<<"$lock")
cef_version=${crate#*+}
current=$(sed -n 's/^  cefVersion = "\(.*\)";$/\1/p' "$ROOT/package.nix")

echo "CEF for riptide $version: $cef_version (packaged: $current)"
if [[ "$cef_version" == "$current" ]]; then
  exit 0
fi

read -r cef_full chromium_version sha1 < <(curl -fsSL https://cef-builds.spotifycdn.com/index.json |
  jq -r --arg build "$cef_version+" '[.linux64.versions[] | select(.cef_version | startswith($build))] | first
    | "\(.cef_version) \(.chromium_version) \([.files[] | select(.type == "minimal") | .sha1] | first)"')
git_revision=${cef_full#*+g}
git_revision=${git_revision%%+*}

url="https://cef-builds.spotifycdn.com/cef_binary_${cef_full}_linux64_minimal.tar.bz2"
{
  read -r hash
  read -r path
} < <(nix-prefetch-url --print-path "$url")
if [[ "$(nix-hash --type sha1 --flat --base16 "$path")" != "$sha1" ]]; then
  echo "$url doesn't match the index's SHA-1 $sha1" >&2
  exit 1
fi
hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$hash")

sed -i -E \
  -e "s/\([0-9.]+\+[0-9.]+ is CEF [0-9.]+\)/($crate is CEF $cef_version)/" \
  -e "s/^(  cefVersion = \")[^\"]*/\1$cef_version/" \
  -e "s/^(  cefGitRevision = \")[^\"]*/\1$git_revision/" \
  -e "s/^(  cefChromiumVersion = \")[^\"]*/\1$chromium_version/" \
  -e "s/^(  cefSha1 = \")[^\"]*/\1$sha1/" \
  -e "s|^(      srcHashes.x86_64-linux = \")[^\"]*|\1$hash|" \
  "$ROOT/package.nix"
