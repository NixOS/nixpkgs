#! @runtimeShell@
# shellcheck shell=bash

case "$1" in
  -h|--help)
    exec man nixos-version
    exit 1
    ;;
  --hash|--revision)
    if ! [[ @revision@ =~ ^[0-9a-f]+$ ]]; then
      echo "$0: Nixpkgs commit hash is unknown" >&2
      exit 1
    fi
    echo "@revision@"
    ;;
  --configuration-revision)
    if [[ "@configurationRevision@" =~ "@" ]]; then
      echo "$0: configuration revision is unknown" >&2
      exit 1
    fi
    echo "@configurationRevision@"
    ;;
  --json)
    cat <<EOF
@json@
EOF
    ;;
  *)
    echo "@version@ (@codeName@)"
    ;;
esac
