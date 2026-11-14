#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git nix-update

set -euo pipefail

pkg_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(realpath "$pkg_dir/../../../..")"
manifest="$pkg_dir/ocr-assets.json"

read_version() {
  sed -n 's/^  version = "\(.*\)";$/\1/p' "$pkg_dir/package.nix" | head -1
}

# Upstream tags alphas and betas; only plain versions count. Cheap enough to run first, so an
# unchanged package costs one ls-remote instead of evaluating the derivation.
latest="$(git ls-remote --tags --refs https://github.com/siyuan-note/siyuan 'v*' \
  | sed 's#.*refs/tags/v##' \
  | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
  | sort -V \
  | tail -1)"
current="$(read_version)"

if [ -z "$latest" ]; then
  echo "could not list the upstream tags" >&2
  exit 1
fi
if [ "$latest" = "$current" ]; then
  echo "siyuan: already at $current"
  exit 0
fi

# Rewrites version, src hash, pnpmDeps and the kernel vendorHash.
cd "$repo_root"
nix-update --file . --version-regex '^v(\d+\.\d+\.\d+)$' --subpackage=kernel siyuan

version="$(read_version)"
if [ -z "$version" ]; then
  echo "could not read the version from $pkg_dir/package.nix" >&2
  exit 1
fi

# ocr-assets.json is a verbatim copy of upstream's scripts/ocr-assets.json. prepare-ocr.py
# verifies the models by hash, so a release that changes them fails the build until this is
# refreshed -- which is why it is part of the update rather than a manual step.
url="https://raw.githubusercontent.com/siyuan-note/siyuan/v${version}/scripts/ocr-assets.json"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fsSL "$url" -o "$tmp"
if cmp -s "$tmp" "$manifest"; then
  echo "ocr-assets.json: unchanged"
else
  cp "$tmp" "$manifest"
  echo "ocr-assets.json: updated for $version"
fi
