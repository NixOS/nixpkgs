#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix gnused gnugrep coreutils git

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pkg_dir="${1:-$script_dir}"

# If passed as a relative path, interpret it relative to the current working directory.
if [[ "$pkg_dir" != /* ]]; then
  pkg_dir="$(cd "$pkg_dir" && pwd)"
fi

# Try to anchor to repo root if we're in a git checkout; otherwise operate from pkg_dir.
if repo_root="$(git -C "$pkg_dir" rev-parse --show-toplevel 2>/dev/null)"; then
  : # ok
else
  repo_root="$(cd "$pkg_dir/../../../../.." && pwd)"
fi

file="$repo_root/pkgs/by-name/sp/sparrow/package.nix"
if [[ ! -f "$file" ]]; then
  # Fallback: allow running against the package dir directly (e.g. in partial checkouts)
  file="$pkg_dir/package.nix"
fi

owner="sparrowwallet"
repo="sparrow"
pname="sparrow"

github_latest_json="$(curl -fsSL "https://api.github.com/repos/${owner}/${repo}/releases/latest")"
version="$(jq -r '.tag_name' <<<"$github_latest_json")"

# Some projects prefix tags with "v". Sparrow currently doesn't, but be resilient.
version="${version#v}"

if [[ -z "$version" || "$version" == "null" ]]; then
  echo "error: failed to determine latest version from GitHub API" >&2
  exit 1
fi

sri_prefetch() {
  local url="$1"
  nix store prefetch-file --json "$url" | jq -r .hash
}

src_x86_url="https://github.com/${owner}/${repo}/releases/download/${version}/sparrowwallet-${version}-x86_64.tar.gz"
src_a64_url="https://github.com/${owner}/${repo}/releases/download/${version}/sparrowwallet-${version}-aarch64.tar.gz"
manifest_url="https://github.com/${owner}/${repo}/releases/download/${version}/${pname}-${version}-manifest.txt"
manifest_sig_url="https://github.com/${owner}/${repo}/releases/download/${version}/${pname}-${version}-manifest.txt.asc"

echo "fetching hashes for sparrow ${version} ..."
src_x86_hash="$(sri_prefetch "$src_x86_url")"
src_a64_hash="$(sri_prefetch "$src_a64_url")"
manifest_hash="$(sri_prefetch "$manifest_url")"
manifest_sig_hash="$(sri_prefetch "$manifest_sig_url")"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

cp -f "$file" "$tmp"

escape_sed_replacement() {
  # Escape '&' and '\' for sed replacement strings.
  # We intentionally use '|' as sed delimiter below to avoid escaping '/' in SRI hashes.
  printf '%s' "$1" | sed -e 's/[&\\]/\\&/g'
}

version_esc="$(escape_sed_replacement "$version")"
src_x86_hash_esc="$(escape_sed_replacement "$src_x86_hash")"
src_a64_hash_esc="$(escape_sed_replacement "$src_a64_hash")"
manifest_hash_esc="$(escape_sed_replacement "$manifest_hash")"
manifest_sig_hash_esc="$(escape_sed_replacement "$manifest_sig_hash")"

# Update version (expects: version = "x.y.z";)
sed -i -E \
  "s|^([[:space:]]*version[[:space:]]*=[[:space:]]*\")([0-9]+\\.[0-9]+\\.[0-9]+)(\";)|\\1${version_esc}\\3|" \
  "$tmp"

# Update src hashes by key (expects exactly these keys)
sed -i -E \
  "s|(x86_64-linux[[:space:]]*=[[:space:]]*\")sha256-[^\"]+(\";)|\\1${src_x86_hash_esc}\\2|" \
  "$tmp"
sed -i -E \
  "s|(aarch64-linux[[:space:]]*=[[:space:]]*\")sha256-[^\"]+(\";)|\\1${src_a64_hash_esc}\\2|" \
  "$tmp"

# Update manifest hash in its fetchurl block
# (scoped to the block by addressing between 'manifest = fetchurl {' and the next '};')
sed -i -E \
  "/^[[:space:]]*manifest[[:space:]]*=[[:space:]]*fetchurl[[:space:]]*\\{/,/^[[:space:]]*\\}[[:space:]]*;/{s|(^[[:space:]]*hash[[:space:]]*=[[:space:]]*\")sha256-[^\"]+(\";)|\\1${manifest_hash_esc}\\2|;}" \
  "$tmp"

# Update manifestSignature hash in its fetchurl block
sed -i -E \
  "/^[[:space:]]*manifestSignature[[:space:]]*=[[:space:]]*fetchurl[[:space:]]*\\{/,/^[[:space:]]*\\}[[:space:]]*;/{s|(^[[:space:]]*hash[[:space:]]*=[[:space:]]*\")sha256-[^\"]+(\";)|\\1${manifest_sig_hash_esc}\\2|;}" \
  "$tmp"

# Sanity checks: ensure we actually wrote the hashes
grep -q "version = \"${version}\";" "$tmp" || { echo "error: failed to update version" >&2; exit 1; }
grep -q "x86_64-linux = \"${src_x86_hash}\";" "$tmp" || { echo "error: failed to update x86_64 hash" >&2; exit 1; }
grep -q "aarch64-linux = \"${src_a64_hash}\";" "$tmp" || { echo "error: failed to update aarch64 hash" >&2; exit 1; }

mv -f "$tmp" "$file"
trap - EXIT

echo "updated ${pname} to ${version}"
echo " - x86_64 src:        ${src_x86_hash}"
echo " - aarch64 src:       ${src_a64_hash}"
echo " - manifest:          ${manifest_hash}"
echo " - manifest signature:${manifest_sig_hash}"
