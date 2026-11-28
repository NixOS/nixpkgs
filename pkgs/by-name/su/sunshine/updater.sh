#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnugrep gnused coreutils curl jq
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

version=$(nix-instantiate --eval --raw -A sunshine.version)
log "Sunshine version: $version"

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

current_build_deps_tag=$(grep -oP 'buildDepsTag = "\K[^"]+' "$package_nix")
if [[ "$build_deps_tag" == "$current_build_deps_tag" ]]; then
    log "build-deps already at $build_deps_tag, nothing to do"
    exit 0
fi

prefetch_unpacked_sri() {
    local raw
    raw=$(nix-prefetch-url --unpack --type sha256 "$1")
    nix-hash --type sha256 --to-sri "$raw"
}

mapfile -t systems < <(nix-instantiate --eval --strict --json -A sunshine.meta.platforms | jq --raw-output '.[]')

sed_args=(-e "s|\"$current_build_deps_tag\"|\"$build_deps_tag\"|")
for system in "${systems[@]}"; do
    old_url=$(nix-instantiate --eval --raw --argstr system "$system" -A sunshine.ffmpegPrebuilt.url)
    old_hash=$(nix-instantiate --eval --raw --argstr system "$system" -A sunshine.ffmpegPrebuilt.outputHash)
    url=${old_url//"$current_build_deps_tag"/"$build_deps_tag"}
    log "Prefetching $url"
    new_hash=$(prefetch_unpacked_sri "$url")
    if [[ -z "$new_hash" ]]; then
        echo "ERROR: failed to prefetch ffmpeg tarball for $system" >&2
        exit 1
    fi
    log "  $system -> $new_hash"
    sed_args+=(-e "s|\"$old_hash\"|\"$new_hash\"|")
done

log "Patching $package_nix"
sed -i "${sed_args[@]}" "$package_nix"
log "Done."
