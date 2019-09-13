#! @shell@

case "$1" in
  -h|--help)
    exec man nixos-version
    exit 1
    ;;
  --hash|--revision)
    echo "@revision@"
    ;;
  --json)
    cat <<EOF
{"nixosVersion": "@version@", "nixpkgsRevision": "@revision@", "configurationRevision": "@configurationRevision@"}
EOF
    ;;
  *)
    echo "@version@ (@codeName@)"
    ;;
esac
