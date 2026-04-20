#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash cacert common-updater-scripts coreutils curl gnutar jq nix nix-update python3

set -euo pipefail

PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIXPKGS_ROOT="$(realpath "$PACKAGE_DIR/../../../..")"
PACKAGE_NIX="$PACKAGE_DIR/package.nix"
LIBRUSTY_V8_NIX="$PACKAGE_DIR/librusty_v8.nix"
ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-codex-acp}"
OWNER="zed-industries"
REPO="codex-acp"

github_api_get() {
  local url="$1"

  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    curl --fail --silent --show-error \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      "$url"
  else
    curl --fail --silent --show-error \
      -H "Accept: application/vnd.github+json" \
      "$url"
  fi
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

parse_release_metadata() {
  local cargo_lock="$1"

  python3 - "$cargo_lock" <<'PY'
import pathlib
import re
import sys

text = pathlib.Path(sys.argv[1]).read_text()

codex_match = re.search(
    r'git\+https://github\.com/openai/codex\?tag=([^#"]+)#([0-9a-f]+)',
    text,
)
if codex_match is None:
    raise SystemExit("Could not find pinned openai/codex dependency in Cargo.lock")

v8_match = re.search(r'\[\[package\]\]\nname = "v8"\nversion = "([^"]+)"', text)
if v8_match is None:
    raise SystemExit('Could not find v8 package version in Cargo.lock')

print(codex_match.group(1))
print(codex_match.group(2))
print(v8_match.group(1))
PY
}

update_codex_pins() {
  python3 - "$PACKAGE_NIX" <<'PY'
import os
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
text = path.read_text()

patterns = [
    (
        r'codexRev = "[0-9a-f]+";',
        f'codexRev = "{os.environ["CODEX_REV"]}";',
        "codexRev",
    ),
    (
        r'codexHash = "sha256-[^"]+";',
        f'codexHash = "{os.environ["CODEX_HASH"]}";',
        "codexHash",
    ),
]

for pattern, replacement, label in patterns:
    text, count = re.subn(pattern, replacement, text, count=1)
    if count != 1:
        raise SystemExit(f"Failed to update {label} in {path}")

path.write_text(text)
PY
}

write_librusty_v8_nix() {
  cat >"$LIBRUSTY_V8_NIX" <<EOF
# auto-generated file -- DO NOT EDIT!
{
  lib,
  stdenv,
  fetchurl,
}:

fetchurl {
  name = "librusty_v8-${V8_VERSION}";
  url = "https://github.com/denoland/rusty_v8/releases/download/v${V8_VERSION}/librusty_v8_release_\${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
  hash =
    {
      x86_64-linux = "${V8_HASH_X86_64_LINUX}";
      aarch64-linux = "${V8_HASH_AARCH64_LINUX}";
      x86_64-darwin = "${V8_HASH_X86_64_DARWIN}";
      aarch64-darwin = "${V8_HASH_AARCH64_DARWIN}";
    }
    .\${stdenv.hostPlatform.system};
  meta = {
    version = "${V8_VERSION}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
EOF
}

cd "$NIXPKGS_ROOT"

current_version="$(nix eval --raw -f . "${ATTR_PATH}.version")"
latest_version="${CODEX_ACP_LATEST_VERSION_OVERRIDE:-}"
if [[ -z "$latest_version" ]]; then
  latest_version="$(github_api_get "https://api.github.com/repos/${OWNER}/${REPO}/releases/latest" | jq --raw-output '.tag_name')"
fi
latest_version="$(normalize_version "$latest_version")"

echo "latest  version: $latest_version"
echo "current version: $current_version"

if [[ "$latest_version" == "$current_version" ]]; then
  echo "codex-acp is already up to date"
  exit 0
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

source_tarball="$tmpdir/codex-acp-${latest_version}.tar.gz"
source_root="$tmpdir/codex-acp-${latest_version}"

curl --fail --silent --show-error --location \
  "https://github.com/${OWNER}/${REPO}/archive/refs/tags/v${latest_version}.tar.gz" \
  --output "$source_tarball"
tar -xzf "$source_tarball" -C "$tmpdir"

mapfile -t release_metadata < <(parse_release_metadata "$source_root/Cargo.lock")
CODEX_TAG="${release_metadata[0]}"
CODEX_REV="${release_metadata[1]}"
V8_VERSION="${release_metadata[2]}"
export CODEX_REV

echo "pinned codex tag: $CODEX_TAG"
echo "pinned codex rev: $CODEX_REV"
echo "pinned v8 version: $V8_VERSION"

src_hash="$(prefetch_sri "https://github.com/${OWNER}/${REPO}/archive/refs/tags/v${latest_version}.tar.gz" true)"
CODEX_HASH="$(prefetch_sri "https://github.com/openai/codex/archive/${CODEX_REV}.tar.gz" true)"
export CODEX_HASH

V8_HASH_X86_64_LINUX="$(prefetch_sri "https://github.com/denoland/rusty_v8/releases/download/v${V8_VERSION}/librusty_v8_release_x86_64-unknown-linux-gnu.a.gz")"
V8_HASH_AARCH64_LINUX="$(prefetch_sri "https://github.com/denoland/rusty_v8/releases/download/v${V8_VERSION}/librusty_v8_release_aarch64-unknown-linux-gnu.a.gz")"
V8_HASH_X86_64_DARWIN="$(prefetch_sri "https://github.com/denoland/rusty_v8/releases/download/v${V8_VERSION}/librusty_v8_release_x86_64-apple-darwin.a.gz")"
V8_HASH_AARCH64_DARWIN="$(prefetch_sri "https://github.com/denoland/rusty_v8/releases/download/v${V8_VERSION}/librusty_v8_release_aarch64-apple-darwin.a.gz")"
export V8_VERSION V8_HASH_X86_64_LINUX V8_HASH_AARCH64_LINUX V8_HASH_X86_64_DARWIN V8_HASH_AARCH64_DARWIN

update-source-version "$ATTR_PATH" "$latest_version" "$src_hash" --ignore-same-version
update_codex_pins
write_librusty_v8_nix
nix-update "$ATTR_PATH" --version skip

echo "updated codex-acp to $latest_version"
