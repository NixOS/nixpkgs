#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts git jq nix nix-prefetch-git
git_url='https://erdgeist.org/gitweb/opentracker'
git_branch='master'
git_dir='/var/tmp/opentracker.git'
nix_file="$(dirname "${BASH_SOURCE[0]}")/default.nix"
pkg='opentracker'

set -euo pipefail

info() {
    if [ -t 2 ]; then
        set -- '\033[32m%s\033[39m\n' "$@"
    else
        set -- '%s\n' "$@"
    fi
    printf "$@" >&2
}

old_rev=$(nix-instantiate --eval --strict --json -A "$pkg.src.rev" | jq -r)

info "fetching $git_url..."
if [ ! -d "$git_dir" ]; then
    git init --initial-branch="$git_branch" "$git_dir"
    git -C "$git_dir" remote add origin "$git_url"
fi
git -C "$git_dir" fetch origin "$git_branch"

new_rev=$(git -C "$git_dir" log -n 1 --format='format:%H' "origin/$git_branch")
info "latest commit: $new_rev"
if [ "$new_rev" = "$old_rev" ]; then
    info "$pkg is up-to-date."
    exit
fi

new_version=$(
    TZ=UTC0 git -C "$git_dir" \
        log -n 1 \
        --format='format:unstable-%cd' \
        --date='format-local:%Y-%m-%d' \
        "$new_rev"
)
new_sha256=$(nix-prefetch-git --rev "$new_rev" "$git_dir" | jq -r .sha256)
update-source-version "$pkg" \
    "$new_version" \
    "$new_sha256" \
    --rev="$new_rev"
