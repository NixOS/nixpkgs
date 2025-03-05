#!/usr/bin/env bash

export PATH="@@out@@/tools:$PATH"

set -eo pipefail

if ! cat /etc/cjdns.keys >/dev/null 2>&1; then
  echo "ERROR: No permission to read /etc/cjdns.keys (use sudo)" >&2
  exit 1
fi

if [[ -z $1 ]]; then
  echo "Cjdns admin"

  echo "Usage: $0 <command> <args..>"

  echo
  echo "Commands:" $(find @@out@@/tools -maxdepth 1 -type f | sed -r "s|.+/||g")

  _sh=$(which sh)
  PATH="@@out@@/tools" PS1="cjdns\$ " "$_sh"
else
  if [[ ! -e @@out@@/tools/$1 ]]; then
    echo "ERROR: '$1' is not a valid tool" >&2
    exit 2
  else
    "$@"
  fi
fi
