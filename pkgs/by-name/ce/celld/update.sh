#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash cacert common-updater-scripts coreutils curl gawk gnused gnutar jq nix-update
# shellcheck shell=bash

set -euo pipefail

PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIXPKGS_ROOT="$(realpath "$PACKAGE_DIR/../../../..")"
LIBRUSTY_V8_NIX="$PACKAGE_DIR/librusty_v8.nix"
ATTR_PATH=celld
OWNER=denoland
REPO=celld

github_api_get() {
  local url="$1"
  local curl_args=(
    --fail
    --silent
    --show-error
    -H "Accept: application/vnd.github+json"
  )

  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    curl_args+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
  fi

  curl "${curl_args[@]}" "$url"
}

normalize_version() {
  local version="$1"
  echo "${version#v}"
}

prefetch_sri() {
  local url="$1"
  local unpack="${2:-false}"
  local raw_hash
  local args=(--type sha256)

  if [[ "$unpack" == "true" ]]; then
    args+=(--unpack)
  fi

  raw_hash="$(nix-prefetch-url "${args[@]}" "$url")"
  nix hash convert --to sri --hash-algo sha256 "$raw_hash"
}

parse_v8_version() {
  local cargo_lock="$1"
  local v8_version

  v8_version="$(
    awk '
      /^\[\[package\]\]$/ { in_pkg = 1; is_v8 = 0; next }
      in_pkg && /^name = "v8"$/ { is_v8 = 1; next }
      in_pkg && is_v8 && /^version = "/ {
        gsub(/^version = "/, "")
        gsub(/"$/, "")
        print
        exit
      }
    ' "$cargo_lock"
  )"

  if [[ -z "$v8_version" ]]; then
    echo "Could not find the v8 package version in Cargo.lock" >&2
    return 1
  fi

  printf '%s\n' "$v8_version"
}

write_librusty_v8_nix() {
  cat >"$LIBRUSTY_V8_NIX" <<EOF
# auto-generated file -- DO NOT EDIT!
{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "${V8_VERSION}";
in
fetchurl {
  name = "librusty_v8-\${version}";
  url = "https://github.com/denoland/rusty_v8/releases/download/v\${version}/librusty_v8_release_\${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
  hash =
    {
      x86_64-linux = "${V8_HASH_X86_64_LINUX}";
      aarch64-linux = "${V8_HASH_AARCH64_LINUX}";
      aarch64-darwin = "${V8_HASH_AARCH64_DARWIN}";
    }
    .\${stdenv.hostPlatform.system}
      or (throw "librusty_v8 \${version} is not available for \${stdenv.hostPlatform.system}");

  meta = {
    inherit version;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
EOF
}

cd "$NIXPKGS_ROOT"

current_version="$(nix eval --raw -f . "${ATTR_PATH}.version")"
latest_version="${CELLD_LATEST_VERSION_OVERRIDE:-}"
if [[ -z "$latest_version" ]]; then
  latest_version="$(github_api_get "https://api.github.com/repos/${OWNER}/${REPO}/releases/latest" | jq --raw-output '.tag_name')"
fi
latest_version="$(normalize_version "$latest_version")"

if [[ -z "$latest_version" || "$latest_version" == "null" ]]; then
  echo "Could not determine the latest celld version" >&2
  exit 1
fi

echo "latest  version: $latest_version"
echo "current version: $current_version"

if [[ "$latest_version" == "$current_version" && "${CELLD_FORCE_UPDATE:-0}" != "1" ]]; then
  echo "celld is already up to date"
  exit 0
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

source_tarball="$tmpdir/celld-${latest_version}.tar.gz"
source_root="$tmpdir/celld-${latest_version}"
source_url="https://github.com/${OWNER}/${REPO}/archive/refs/tags/v${latest_version}.tar.gz"

curl --fail --silent --show-error --location \
  "$source_url" \
  --output "$source_tarball"
tar -xzf "$source_tarball" -C "$tmpdir"

V8_VERSION="$(parse_v8_version "$source_root/Cargo.lock")"
echo "pinned v8 version: $V8_VERSION"

src_hash="$(prefetch_sri "$source_url" true)"
V8_HASH_X86_64_LINUX="$(prefetch_sri "https://github.com/denoland/rusty_v8/releases/download/v${V8_VERSION}/librusty_v8_release_x86_64-unknown-linux-gnu.a.gz")"
V8_HASH_AARCH64_LINUX="$(prefetch_sri "https://github.com/denoland/rusty_v8/releases/download/v${V8_VERSION}/librusty_v8_release_aarch64-unknown-linux-gnu.a.gz")"
V8_HASH_AARCH64_DARWIN="$(prefetch_sri "https://github.com/denoland/rusty_v8/releases/download/v${V8_VERSION}/librusty_v8_release_aarch64-apple-darwin.a.gz")"
export V8_VERSION V8_HASH_X86_64_LINUX V8_HASH_AARCH64_LINUX V8_HASH_AARCH64_DARWIN

update-source-version "$ATTR_PATH" "$latest_version" "$src_hash" --ignore-same-version
write_librusty_v8_nix
nix-update "$ATTR_PATH" --version skip

echo "updated celld to $latest_version"
