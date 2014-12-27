#! @shell@

case "$1" in
  --hash|--revision)
    echo "@nixosRevision@"
    ;;
  *)
    echo "@nixosVersion@ (@nixosCodeName@)"
    ;;
esac
