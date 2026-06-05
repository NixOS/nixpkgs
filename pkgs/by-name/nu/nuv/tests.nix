{
  runCommand,
  nuv,
  version,
}:

runCommand "nuv-test-run"
  {
    nativeBuildInputs = [ nuv ];
  }
  ''
    export TMP_BASE=$(mktemp -d /tmp/.nuv-XXXXX)
    export HOME=$TMP_BASE
    export NUV_REPO=""
    export NUV_ROOT=$TMP_BASE/.nuv/3.0.0/olaris
    rm -rf $TMP_BASE/.nuv && \
      mkdir -p $TMP_BASE/.nuv/3.0.0/olaris && \
      mkdir $TMP_BASE/.nuv/tmp
    V=$(nuv -version 2>/dev/null)
    diff -U3 --color=auto <(echo "$V") <(echo "${version}")
    touch $out
  ''
