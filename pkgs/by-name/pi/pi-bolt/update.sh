#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix coreutils common-updater-scripts gnutar prefetch-npm-deps
set -eu -o pipefail

latestVersion=$(curl -sIL -o /dev/null -w '%{url_effective}' https://github.com/opensec-git/Pi-Bolt/releases/latest | sed 's#.*/bolt-v##')
currentVersion=$(nix eval --raw -f . pi-bolt.version)

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
  echo "package is up-to-date"
  exit 0
fi

# Source: fetchFromGitHub, tag bolt-vX.Y.Z (the tag follows version).
sourceHash=$(nix-prefetch-url --unpack "https://github.com/opensec-git/Pi-Bolt/archive/refs/tags/bolt-v${latestVersion}.tar.gz")
sourceSri=$(nix-hash --to-sri --type sha256 "$sourceHash")
update-source-version pi-bolt "$latestVersion" "$sourceSri" --ignore-same-version

# npm deps tree for the new source (fetchNpmDeps; no import-from-derivation).
lockdir=$(mktemp -d)
curl -sL "https://github.com/opensec-git/Pi-Bolt/archive/refs/tags/bolt-v${latestVersion}.tar.gz" |
  tar xz -C "$lockdir" --strip-components=1 --wildcards '*/package-lock.json'
npmDepsHash=$(prefetch-npm-deps "$lockdir/package-lock.json")
sed -i -E "s|npmDepsHash = \"[^\"]+\"|npmDepsHash = \"$npmDepsHash\"|" pkgs/by-name/pi/pi-bolt/package.nix

# Runtime assets: one fetchurl per platform.
for platform in x86_64-linux aarch64-linux aarch64-darwin; do
  case "$platform" in
  x86_64-linux) asset=linux-x64 ;;
  aarch64-linux) asset=linux-arm64 ;;
  aarch64-darwin) asset=darwin-arm64 ;;
  esac
  url="https://github.com/opensec-git/Pi-Bolt/releases/download/bolt-v${latestVersion}/pi-bolt-runtime-${asset}.tar.gz"
  source=$(nix-prefetch-url "$url" --name "pi-bolt-runtime-${asset}-${latestVersion}")
  hash=$(nix-hash --to-sri --type sha256 "$source")
  update-source-version pi-bolt "$latestVersion" "$hash" "$url" --system="$platform" --source-key="runtimeAssets.$platform" --ignore-same-version
done

# Engine stamp: a release file, not a Nix source.
stamp=$(curl -fsSL "https://github.com/opensec-git/Pi-Bolt/releases/download/bolt-v${latestVersion}/RUNTIME_STAMP")
if [[ ! "$stamp" =~ ^[0-9a-f]{16}$ ]]; then
  echo "unexpected RUNTIME_STAMP: $stamp" >&2
  exit 1
fi
sed -i -E "s/runtimeStamp = \"[0-9a-f]{16}\"/runtimeStamp = \"$stamp\"/" pkgs/by-name/pi/pi-bolt/package.nix
