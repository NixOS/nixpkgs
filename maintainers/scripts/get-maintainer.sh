#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq ncurses
# shellcheck shell=bash

set -euo pipefail

declare -A SELECTORS=( [handle]= [email]= [github]= [githubId]= [matrix]= [name]= )
MAINTAINERS_DIR="$(dirname $0)/.."

die() {
  tput setaf 1 # red
  echo "$@"
  tput setaf 0 # back to black
  exit 1
}

listAsJSON() {
  nix-instantiate --eval --strict --json "${MAINTAINERS_DIR}/maintainer-list.nix"
}

parseArgs() {
  [ $# -gt 0 -a $# -lt 3 ] || \
    die "usage: '$0' [selector] value"

  if [ $# -eq 1 ]; then
    selector=handle
  else
    selector="$1"
    shift
  fi
  [ -z "${SELECTORS[$selector]-n}" ] || {
    echo "Valid selectors are: ${!SELECTORS[@]}" >&2
    die "'$0': invalid selector '$selector'"
  }

  value="$1"
  shift
}

query() {
  # explode { a: A, b: B, ... } into A + {handle: a}, B + {handle: b}, ...
  local explode="to_entries[] | .value + { \"handle\": .key }"

  # select matching items from the list
  # TODO(nicoo): Support approximate matching for `name` ?
  local select
  case "$selector" in
    githubId)
      select="select(.${selector} == $value)"
      ;;
    *)
      select="select(.${selector} == \"$value\")"
  esac

  echo "$explode | $select"
}

parseArgs "$@"
listAsJSON | jq -e "$(query)"
