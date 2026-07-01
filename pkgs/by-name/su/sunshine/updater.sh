#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnugrep gnused coreutils curl jq nix-update nix-prefetch-git
# shellcheck shell=bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
package_nix="$script_dir/package.nix"
nixpkgs_root="$(cd "$script_dir/../../../.." && pwd)"
cd "$nixpkgs_root"

log() {
    printf '\n==> %s\n' "$*" >&2
}

api() {
    curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --location "$@"
}

log "Querying latest Sunshine release from GitHub"
version=$(api https://api.github.com/repos/LizardByte/Sunshine/releases/latest | jq --raw-output .tag_name | grep -oP "^v\K.*")
log "Latest version: $version"

if [[ "${UPDATE_NIX_OLD_VERSION:-}" == "$version" ]]; then
    log "Already up to date!"
    exit 0
fi

log "Updating sunshine version (src hash refreshed separately, see below)"
# --no-src: nix-update can't fetch submodules, so we refresh the src hash
# ourselves via nix-prefetch-git below.
nix-update sunshine --version "$version" --no-src

log "Prefetching sunshine src with submodules (this can take several minutes)"
# nix-prefetch-git outputs SRI under .hash on recent versions. The submodule
# tree NAR-hashes identically on Linux and Darwin, so one hash serves both.
src_hash=$(nix-prefetch-git \
    --quiet \
    --fetch-submodules \
    --url "https://github.com/LizardByte/Sunshine" \
    --rev "v$version" \
    | jq --raw-output .hash)

if [[ -z "$src_hash" || "$src_hash" == "null" ]]; then
    echo "ERROR: failed to prefetch sunshine src hash" >&2
    exit 1
fi
log "src hash: $src_hash"

log "Patching src hash in $package_nix"
# The src fetchFromGitHub is the only one with fetchSubmodules; anchor on it so
# we don't touch the ffmpeg or npmDepsHash entries. sed -z spans newlines.
sed -i -zE "s#hash = \"sha256-[A-Za-z0-9+/=]+\"(\\s*fetchSubmodules = true;)#hash = \"$src_hash\"\\1#" "$package_nix"

if ! grep -q "$src_hash" "$package_nix"; then
    echo "ERROR: failed to write src hash into $package_nix" >&2
    exit 1
fi

log "Regenerating sunshine.ui package-lock.json"
# `--generate-lockfile` only regenerates package-lock.json; it skips the npmDepsHash
# refresh (see nix-update's dependency_hashes.py). Run a second pass to update the hash.
# `--no-src` avoids re-fetching the (already-pinned) sunshine src on each pass.
nix-update sunshine --version=skip --no-src --generate-lockfile --subpackage ui

log "Refreshing sunshine.ui npmDepsHash"
nix-update sunshine --version=skip --no-src --subpackage ui

# Update the LizardByte/build-deps tag and pinned ffmpeg tarball hashes.
# Sunshine pins build-deps via a git submodule at third-party/build-deps; the
# tag we need is whichever build-deps release tag points at that submodule's
# commit.
log "Resolving LizardByte/build-deps submodule commit and tag"
build_deps_sha=$(api "https://api.github.com/repos/LizardByte/Sunshine/contents/third-party?ref=v$version" \
    | jq --raw-output '.[] | select(.name=="build-deps") | .sha')
log "build-deps submodule commit: $build_deps_sha"
build_deps_tag=$(api "https://api.github.com/repos/LizardByte/build-deps/tags?per_page=100" \
    | jq --raw-output --arg sha "$build_deps_sha" '.[] | select(.commit.sha==$sha) | .name' \
    | head -n1)

if [[ -z "$build_deps_tag" ]]; then
    echo "ERROR: no LizardByte/build-deps tag points at submodule commit $build_deps_sha" >&2
    exit 1
fi
log "build-deps tag: $build_deps_tag"

# Compute the SRI hash of a `fetchzip` (default stripRoot=true) for a URL.
# `nix-prefetch-url --unpack` produces the same NAR hash AND caches by URL
# (whereas the empty-hash + fetchzip trick re-downloads every invocation).
prefetch_unpacked_sri() {
    local raw
    raw=$(nix-prefetch-url --unpack --type sha256 "$1")
    nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$raw"
}

ffmpeg_url() {
    echo "https://github.com/LizardByte/build-deps/releases/download/$build_deps_tag/$1-ffmpeg.tar.gz"
}

# Map nix system → upstream tarball arch token. Keep this in sync with the
# `ffmpegArch` attrset in package.nix.
declare -A ffmpeg_arch=(
    [x86_64-linux]=Linux-x86_64
    [aarch64-linux]=Linux-aarch64
    [x86_64-darwin]=Darwin-x86_64
    [aarch64-darwin]=Darwin-arm64
)

declare -A ffmpeg_hash
for system in "${!ffmpeg_arch[@]}"; do
    log "Prefetching ffmpeg tarball for $system (${ffmpeg_arch[$system]})"
    h=$(prefetch_unpacked_sri "$(ffmpeg_url "${ffmpeg_arch[$system]}")")
    if [[ -z "$h" ]]; then
        echo "ERROR: failed to prefetch ffmpeg tarball for $system" >&2
        exit 1
    fi
    log "  $system -> $h"
    ffmpeg_hash[$system]=$h
done

log "Patching $package_nix"
sed_args=(-E -e "s#buildDepsTag = \"v[^\"]*\";#buildDepsTag = \"$build_deps_tag\";#")
for system in "${!ffmpeg_hash[@]}"; do
    sed_args+=(-e "s#$system = (lib\\.fakeHash|\"sha256-[A-Za-z0-9+/=]+\");#$system = \"${ffmpeg_hash[$system]}\";#")
done
sed -i "${sed_args[@]}" "$package_nix"
log "Done."
