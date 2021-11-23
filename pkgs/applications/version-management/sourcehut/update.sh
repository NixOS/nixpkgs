#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git mercurial common-updater-scripts
# shellcheck shell=bash

cd "$(dirname "${BASH_SOURCE[0]}")"
root=../../../..

default() {
  (cd "$root" && nix-instantiate --eval --strict -A "sourcehut.python.pkgs.$1.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
}

version() {
  (cd "$root" && nix-instantiate --eval --strict -A "sourcehut.python.pkgs.$1.version" | tr -d '"')
}

src_url() {
  (cd "$root" && nix-instantiate --eval --strict -A "sourcehut.python.pkgs.$1.src.drvAttrs.url" | tr -d '"')
}

get_latest_version() {
  src="$(src_url "$1")"
  tmp=$(mktemp -d)

  if [ "$1" = "hgsrht" ]; then
    hg clone "$src" "$tmp" &> /dev/null
    printf "%s" "$(cd "$tmp" && hg log --limit 1 --template '{latesttag}')"
  else
    git clone "$src" "$tmp"
    printf "%s" "$(cd "$tmp" && git describe $(git rev-list --tags --max-count=1))"
  fi
}

update_version() {
  default_nix="$(default "$1")"
  version_old="$(version "$1")"
  version="$(get_latest_version "$1")"

  (cd "$root" && update-source-version "sourcehut.python.pkgs.$1" "$version")

  git add "$default_nix"
  git commit -m "$1: $version_old -> $version"
}

services=( "srht" "buildsrht" "dispatchsrht" "gitsrht" "hgsrht" "hubsrht" "listssrht" "mansrht"
           "metasrht" "pastesrht" "todosrht" "scmsrht" )

# Whether or not a specific service is requested
if [ -n "$1" ]; then
  version="$(get_latest_version "$1")"
  (cd "$root" && update-source-version "sourcehut.python.pkgs.$1" "$version")
else
  for service in "${services[@]}"; do
    update_version "$service"
  done
fi
