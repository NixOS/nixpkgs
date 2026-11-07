#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused curl jq git nix prefetch-yarn-deps coreutils python3 rustup nix-prefetch-git nix-prefetch-github

set -euo pipefail

pkgdir="$(cd "$(dirname "$0")" && pwd)"
nixpkgs="$(cd "$pkgdir/../../../.." && pwd)"
pkgfile="$pkgdir/package.nix"
remote_repo="https://github.com/facebook/sapling.git"
latest_tag="$(
  git ls-remote --tags --refs "$remote_repo" \
    | awk '{print $2}' \
    | sed 's|^refs/tags/||' \
    | grep -E '^0\.2\.[0-9]{8}-[0-9]{6}\+[0-9a-f]{7,}$' \
    | sort \
    | tail -n 1
)"

if [[ -z "$latest_tag" ]]; then
  echo "Error: unable to determine latest tag" >&2
  exit 1
fi

echo "Latest tag: $latest_tag"

tarball_url="https://github.com/facebook/sapling/archive/refs/tags/${latest_tag}.tar.gz"

# Update version
sed -i 's|^  version = "[^"]*";|  version = "'"$latest_tag"'";|' "$pkgfile"

# Prefetch source tarball
tarball_output="$(nix-prefetch-url --print-path --unpack "$tarball_url")"
src_hash_raw="$(echo "$tarball_output" | head -1)"
source_dir="$(echo "$tarball_output" | tail -1)"

# Regenerate Cargo.lock via cargo fetch
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
export TMPDIR="$tmpdir"
export RUSTUP_HOME="$tmpdir/rustup"
export CARGO_HOME="$tmpdir/cargo"
mkdir -p "$RUSTUP_HOME" "$CARGO_HOME"

rustup toolchain install nightly --profile minimal --force
cp -R "$source_dir" "$tmpdir/src"
chmod -R u+w "$tmpdir/src"

# Remove [patch.crates-io] to prevent cargo from cloning git repos during fetch
sed -i '/^\[patch\.crates-io\]$/,/^$/d' "$tmpdir/src/eden/scm/Cargo.toml"

rustup run nightly cargo fetch --manifest-path "$tmpdir/src/eden/scm/Cargo.toml"
cp "$tmpdir/src/eden/scm/Cargo.lock" "$pkgdir/Cargo.lock"

# Discover fetchCargoVendor hash: set hash empty, build, capture the "got:" hash from nix error output
sed -i 's|^    hash = "[^"]*";|    hash = "";|' "$pkgfile"
vendor_hash_raw="$(nix build "$nixpkgs#sapling" --no-link 2>&1 \
  | grep -o 'got:.*sha256-[A-Za-z0-9/+]*=' \
  | head -1 \
  | sed 's/^got:[[:space:]]*//' \
  || true)"

if [[ -n "$vendor_hash_raw" ]]; then
  sed -i 's|^    hash = "[^"]*";|    hash = "'"$vendor_hash_raw"'";|' "$pkgfile"
  echo "fetchCargoVendor hash: $vendor_hash_raw"
else
  echo "WARNING: could not determine fetchCargoVendor hash" >&2
fi

# Update fetchFromGitHub hash
src_hash_sri="$(nix hash convert --hash-algo sha256 --to sri "$src_hash_raw")"
sed -i 's|hash = "[^"]*";|hash = "'"$src_hash_sri"'";|' "$pkgfile"

# Update yarn offline cache hash
sed 's|https://registry.facebook.net|https://registry.npmjs.org|g' \
  "$source_dir/addons/yarn.lock" > "$tmpdir/yarn.lock"

yarn_hash_raw="$(NODE_NO_WARNINGS=1 prefetch-yarn-deps "$tmpdir/yarn.lock")"
if [[ -z "$yarn_hash_raw" ]]; then
  echo "Error: prefetch-yarn-deps returned empty hash" >&2
  exit 1
fi

yarn_hash_sri="$(nix hash convert --hash-algo sha256 --to sri "$yarn_hash_raw")"
sed -i 's|sha256 = "[^"]*";|sha256 = "'"$yarn_hash_sri"'";|' "$pkgfile"

echo "Updated to $latest_tag"
