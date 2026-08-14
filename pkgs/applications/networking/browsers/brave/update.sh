#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq nix gclient2nix prefetch-npm-deps nodejs
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
lock_path="$script_dir/source-lock.json"
deps_path="$script_dir/gclient-deps.json"
wdp_lock_path="$script_dir/web-discovery-project.package-lock.json"

version="${1:-}"
if [[ -z "$version" ]]; then
  echo "usage: $0 <brave-version-without-v-prefix>" >&2
  exit 1
fi

brave_rev="v${version}"
brave_tarball_url="https://github.com/brave/brave-core/archive/refs/tags/${brave_rev}.tar.gz"

echo "==> Prefetching brave-core ${brave_rev}" >&2
raw_hash="$(nix-prefetch-url --type sha256 --unpack "$brave_tarball_url")"
brave_hash="$(nix hash convert --hash-algo sha256 --to sri "$raw_hash")"

echo "==> Prefetching brave-core npm deps (forceGitDeps)" >&2
brave_src="$(nix-build --no-out-link -E "with import <nixpkgs> {}; fetchFromGitHub { owner = \"brave\"; repo = \"brave-core\"; rev = \"${brave_rev}\"; hash = \"${brave_hash}\"; }")"
brave_npm_hash="$(
  FORCE_GIT_DEPS=1 prefetch-npm-deps "$brave_src/package-lock.json"
)"

echo "==> Regenerating gclient graph (this may take a while)" >&2
tmp_deps="$(mktemp)"
normalized_deps="$(mktemp)"
chromium_deps_tmp="$(mktemp)"
wdp_tmp="$(mktemp -d)"
trap 'rm -f "$tmp_deps" "$normalized_deps" "$chromium_deps_tmp"; rm -rf "$wdp_tmp"' EXIT

gclient2nix generate --root "src/brave" "https://github.com/brave/brave-core@${brave_rev}" > "$tmp_deps"

# `gclient2nix generate --root src/brave` flattens Brave-core deps, but in
# practice does not expose Chromium's `src` entry. We therefore keep the
# Chromium pins from the existing lock file.
chromium_rev="$(
  jq -r '.chromium.rev // empty' "$lock_path" 2>/dev/null || true
)"
chromium_hash="$(
  jq -r '.chromium.hash // empty' "$lock_path" 2>/dev/null || true
)"
chromium_npm_hash="$(
  jq -r '.chromium_npm_hash // empty' "$lock_path" 2>/dev/null || true
)"

if [[ -z "$chromium_rev" || -z "$chromium_hash" ]]; then
  echo "chromium pins missing from $lock_path (need .chromium.rev and .chromium.hash)" >&2
  echo "please bootstrap source-lock.json once, then rerun update.sh" >&2
  exit 1
fi

# Normalize generated gclient-deps keys under the Brave checkout:
# Brave DEPS paths are relative to `src/brave` (e.g. `third_party/...`,
# `vendor/...`). gclient2nix may emit `/third_party/...` or `src/...`;
# map those to `src/brave/...`. Keep Chromium `src` and `src/brave` roots.
jq '
  with_entries(
    if (.key == "src" or .key == "src/brave") then .
    else
      .key |= (
        if startswith("src/brave/") then .
        elif startswith("src/") then ("src/brave/" + .[4:])
        elif startswith("/") then ("src/brave" + .)
        else ("src/brave/" + .)
        end
      )
    end
  )
' "$tmp_deps" > "$normalized_deps"

jq -n \
  --arg chromiumRev "$chromium_rev" \
  --arg chromiumHash "$chromium_hash" \
  '{
    "src": {
      fetcher: "fetchFromGitiles",
      args: {
        url: "https://chromium.googlesource.com/chromium/src.git",
        rev: $chromiumRev,
        hash: $chromiumHash
      }
    }
  }' > "$chromium_deps_tmp"

jq -s '.[0] * .[1]' "$chromium_deps_tmp" "$normalized_deps" > "$deps_path"

wdp_key="src/brave/vendor/web-discovery-project"
wdp_rev="$(jq -r --arg k "$wdp_key" '.[$k].args.rev // empty' "$deps_path")"
wdp_hash="$(jq -r --arg k "$wdp_key" '.[$k].args.hash // empty' "$deps_path")"
if [[ -z "$wdp_rev" || -z "$wdp_hash" ]]; then
  echo "missing $wdp_key in $deps_path" >&2
  exit 1
fi

echo "==> Regenerating web-discovery-project package-lock (resolved URLs)" >&2
wdp_src="$(
  nix-build --no-out-link -E "with import <nixpkgs> {}; fetchFromGitHub {
    owner = \"brave\";
    repo = \"web-discovery-project\";
    rev = \"${wdp_rev}\";
    hash = \"${wdp_hash}\";
  }"
)"
cp -a "$wdp_src/." "$wdp_tmp/"
chmod -R u+w "$wdp_tmp"
(
  cd "$wdp_tmp"
  rm -f package-lock.json
  npm install --package-lock-only --ignore-scripts
)
cp "$wdp_tmp/package-lock.json" "$wdp_lock_path"

echo "==> Prefetching web-discovery-project npm deps" >&2
wdp_npm_hash="$(
  nix-build --no-out-link -E "with import <nixpkgs> {};
    let
      raw = fetchFromGitHub {
        owner = \"brave\";
        repo = \"web-discovery-project\";
        rev = \"${wdp_rev}\";
        hash = \"${wdp_hash}\";
      };
      fixed = runCommand \"wdp-with-lock\" {} ''
        mkdir -p \$out
        cp -a \${raw}/. \$out/
        chmod -R u+w \$out
        cp ${wdp_lock_path} \$out/package-lock.json
      '';
    in fetchNpmDeps {
      name = \"web-discovery-project-npm-deps\";
      src = fixed;
      hash = \"\";
    }" 2>&1 | sed -n 's/.*got: *//p' | tail -n1
)"
if [[ -z "$wdp_npm_hash" ]]; then
  echo "failed to compute web-discovery-project npm hash" >&2
  exit 1
fi

jq -n \
  --arg version "$version" \
  --arg braveRev "$brave_rev" \
  --arg braveHash "$brave_hash" \
  --arg braveNpmHash "$brave_npm_hash" \
  --arg wdpNpmHash "$wdp_npm_hash" \
  --arg chromiumRev "$chromium_rev" \
  --arg chromiumHash "$chromium_hash" \
  --arg chromiumNpmHash "$chromium_npm_hash" \
  '{
    version: $version,
    braveCore: {
      owner: "brave",
      repo: "brave-core",
      rev: $braveRev,
      hash: $braveHash
    },
    braveCore_npm_hash: $braveNpmHash,
    webDiscoveryProject_npm_hash: $wdpNpmHash,
    chromium: {
      url: "https://chromium.googlesource.com/chromium/src.git",
      rev: $chromiumRev,
      hash: $chromiumHash
    },
    chromium_npm_hash: $chromiumNpmHash
  }' > "$lock_path"

trap - EXIT
rm -f "$tmp_deps" "$normalized_deps" "$chromium_deps_tmp"
rm -rf "$wdp_tmp"

echo "==> Updated:" >&2
echo "    $lock_path" >&2
echo "    $deps_path" >&2
echo "    $wdp_lock_path" >&2
