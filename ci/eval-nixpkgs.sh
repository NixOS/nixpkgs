#!/usr/bin/env bash

set -euxo pipefail

system="x86_64-linux"

parseArgs() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --system)
        system=$2
        shift
        ;;
      *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
  done
}

main() {
    parseArgs "$@"
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT
    (
      set +e
      nix-env -f . \
          -qa \* \
          --meta \
          --xml \
          --drv-path \
          --show-trace \
          --eval-system "$system" \
          > "$tmpdir/store-path"
      echo $? > "$tmpdir/exit-code"
    ) &
    pid=$!
    while kill -0 "$pid"; do
        free -g
        sleep 20
    done
    exit "$(cat "$tmpdir/exit-code")"
}

main
