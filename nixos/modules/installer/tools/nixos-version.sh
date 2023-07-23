#! @runtimeShell@
# shellcheck shell=bash

case "$1" in
  -h|--help)
    exec man nixos-version
    exit 1
    ;;
  --hash|--revision)
    revision="$(jq --raw-output '.nixpkgsRevision // "null"' < @nixosVersionJson@)"
    if [ "$revision" == "null" ]; then
      echo "$0: Nixpkgs commit hash is unknown" >&2
      exit 1
    fi
    echo "$revision"
    ;;
  --configuration-revision)
    revision="$(jq --raw-output '.configurationRevision // "null"' < @nixosVersionJson@)"
    if [ "$revision" == "null" ]; then
      echo "$0: configuration revision is unknown" >&2
      exit 1
    fi
    echo "$revision"
    ;;
  --json)
    cat @nixosVersionJson@
    ;;
  *)
    jq --raw-output '.nixosVersion + " (" + .nixosCodeName + ")"' < @nixosVersionJson@
    ;;
esac
