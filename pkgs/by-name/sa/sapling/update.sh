#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq git gnused nix-prefetch-github cargo python3 nix prefetch-yarn-deps coreutils

set -euo pipefail

# Paths
nixpkgs="$(git rev-parse --show-toplevel)"
pkgdir="$nixpkgs/pkgs/by-name/sa/sapling"
pkgfile="$pkgdir/package.nix"
latest_json="$(curl -s https://api.github.com/repos/facebook/sapling/releases/latest)"
latest_tag="$(jq -r .tag_name <<<"$latest_json")"
tarball_url="$(jq -r .tarball_url <<<"$latest_json")"

# Prefetch source tarball and get unpacked path
mapfile -t tarball_lines < <(nix-prefetch-url --print-path --unpack "$tarball_url")
source_dir="${tarball_lines[1]}"

# Update Cargo.lock by running cargo fetch in a writable copy of the source
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cp -R "$source_dir" "$tmpdir/src"
chmod -R u+w "$tmpdir/src"
(cd "$tmpdir/src/eden/scm" && cargo fetch)
cp "$tmpdir/src/eden/scm/Cargo.lock" "$pkgdir/Cargo.lock"

# Compute versionHash (first 8 bytes of SHA1(version) as big-endian u64)
version_hash="$(python3 -c 'import hashlib,struct,sys; s=sys.argv[1].encode("ascii"); print(struct.unpack(">Q", hashlib.sha1(s).digest()[:8])[0])' "$latest_tag")"
sed -i -e 's|^  version = "[^"]*";|  version = "'"$latest_tag"'";|' "$pkgfile"
sed -i -e 's|^  versionHash = "[^"]*";|  versionHash = "'"$version_hash"'";|' "$pkgfile"

# Prefetch source hash for fetchFromGitHub
src_hash="$(nix-prefetch-github facebook sapling --rev "$latest_tag" | jq -r '.hash')"

# Update the fetchFromGitHub src block's hash
sed -i -e '/src = fetchFromGitHub {/,/}/{s|hash = "[^"]*";|hash = "'"$src_hash"'";|}' "$pkgfile"

# Compute yarn offline cache hash without building
yarn_lock="$source_dir/addons/yarn.lock"
yarn_hash_raw="$(prefetch-yarn-deps "$yarn_lock")"
yarn_hash_sri="$(nix hash convert --hash-algo sha256 --to sri "$yarn_hash_raw")"
sed -i -e '/yarnOfflineCache = fetchYarnDeps {/,/};/ {s|sha256 = "[^"]*";|sha256 = "'"$yarn_hash_sri"'";|}' "$pkgfile"
