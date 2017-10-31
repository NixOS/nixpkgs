#! @shell@

case "$1" in
  -h|--help)
    exec man nixos-version
    exit 1
    ;;
  --hash|--revision)
    echo "@nixosRevision@"
    ;;
  *)
    echo "@nixosVersion@ (@nixosCodeName@)"
    ;;
esac
