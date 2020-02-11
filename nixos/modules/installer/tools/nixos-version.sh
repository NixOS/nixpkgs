#! @shell@

case "$1" in
  -h|--help)
    exec man nixos-version
    exit 1
    ;;
  --hash|--revision)
    if ! [[ @revision@ =~ ^[0-9a-f]+$ ]]; then
      echo "$0: Nixpkgs commit hash is unknown"
      exit 1
    fi
    echo "@revision@"
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
