#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash
#!nix-shell -p cacert curl git jq nix-prefetch-git
# shellcheck shell=bash
# vim: set tabstop=2 shiftwidth=2 expandtab:
set -euo pipefail
shopt -s inherit_errexit

[ $# -gt 0 ] || {
  printf >&2 'usage: %s <deps>' "$0"
  exit 1
}

pkgpath=$(git rev-parse --show-toplevel)/pkgs/by-name/sk/skia-aseprite
depfilter=$(tr ' ' '|' <<< "$*")
depfile=$pkgpath/deps.nix
pkgfile=$pkgpath/package.nix

update_deps() {
  local deps third_party_deps name url rev hash prefetch

  version=$(sed -n 's|.*version = "\(.*\)".*|\1|p' < "$pkgfile")
  deps=$(curl -fsS https://raw.githubusercontent.com/aseprite/skia/$version/DEPS)
  third_party_deps=$(sed -n 's|[ ",]||g; s|:| |; s|@| |; s|^third_party/externals/||p' <<< "$deps")
  filtered=$(grep -E -- "$depfilter" <<< "$third_party_deps")
  if [[ -z $filtered ]]; then
    printf >&2 '%s: error: filter "%s" matched nothing' "$0" "$depfilter"
    return 1
  fi

  printf '{ fetchgit }:\n{\n'
  while read -r name url rev; do
    printf >&2 'Fetching %s@%s\n' "$name" "$rev"
    prefetch=$(nix-prefetch-git --quiet --rev "$rev" "$url")
    hash=$(jq -r '.hash' <<< "$prefetch")

    cat << EOF
  $name = fetchgit {
    url = "$url";
    rev = "$rev";
    hash = "$hash";
  };
EOF
  # `read` could exit with a non-zero code without a newline at the end
  done < <(printf '%s\n' "$filtered")
  printf '}\n'
}

update_version() {
  local newver newrev
  newver=$(
    curl --fail \
      --header 'Accept: application/vnd.github+json' \
      --location --show-error --silent \
      ${GITHUB_TOKEN:+ --user \":$GITHUB_TOKEN\"} \
      https://api.github.com/repos/aseprite/skia/releases/latest \
      | jq -r .tag_name
  )
  newhash=$(nix-prefetch-git --quiet --rev "$newver" https://github.com/aseprite/skia.git | jq -r '.hash')
  sed \
    -e 's|version = ".*"|version = "'$newver'"|' \
    -e 's|hash = ".*"|hash = "'$newhash'"|' \
    -- "$pkgfile"
}

temp=$(mktemp)
trap 'ret=$?; rm -rf -- "$temp"; exit $ret' EXIT
update_version > "$temp"
cp "$temp" "$pkgfile"
update_deps > "$temp"
cp "$temp" "$depfile"
