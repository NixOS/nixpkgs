#!/usr/bin/env bash

set -euxo pipefail

system="x86_64-linux"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
NIXPKGS_PATH="$(readlink -f $SCRIPT_DIR/..)"

parseArgs() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --system)
        system=$2
        shift 2
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
      nix-env \
        --arg "supportedSystems" "[\"$system\"]" \
        -qaP --no-name \
        --out-path \
        --arg checkMeta true \
        --argstr path "$NIXPKGS_PATH" \
        -f "$SCRIPT_DIR/outpaths.nix" > "$tmpdir/paths"
      echo $? > "$tmpdir/exit-code"
    ) &
    pid=$!
    while kill -0 "$pid"; do
        free -g
        sleep 20
    done
    exit "$(cat "$tmpdir/exit-code")"
}

main "$@"
