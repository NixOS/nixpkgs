{
  stdenv,
  lib,
  fetchFromGitHub,
  libuuid,
  curl,
  pkg-config,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  tlsSupport ? !stdenv.hostPlatform.isStatic,
  openssl,
  jemalloc,
  which,
  tcl,
  tcltls,
  ps,
  getconf,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keydb";
  version = "6.3.4";

  src = fetchFromGitHub {
    owner = "snapchat";
    repo = "keydb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j6qgK6P3Fv+b6k9jwKQ5zW7XLkKbXXcmHKBCQYvwEIU=";
  };

  postPatch = ''
    substituteInPlace deps/lua/src/Makefile \
      --replace-fail "ar rcu" "${stdenv.cc.targetPrefix}ar rcu"
    substituteInPlace src/Makefile \
      --replace-fail "as --64 -g" "${stdenv.cc.targetPrefix}as --64 -g"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    jemalloc
    curl
    libuuid
  ] ++ lib.optionals tlsSupport [ openssl ] ++ lib.optionals withSystemd [ systemd ];

  makeFlags =
    [
      "PREFIX=${placeholder "out"}"
      "AR=${stdenv.cc.targetPrefix}ar"
      "RANLIB=${stdenv.cc.targetPrefix}ranlib"
      "USEASM=${if stdenv.isx86_64 then "true" else "false"}"
    ]
    ++ lib.optionals (!tlsSupport) [ "BUILD_TLS=no" ]
    ++ lib.optionals withSystemd [ "USE_SYSTEMD=yes" ]
    ++ lib.optionals (!stdenv.isx86_64) [ "MALLOC=libc" ];

  enableParallelBuilding = true;

  hardeningEnable = lib.optionals (!stdenv.isDarwin) [ "pie" ];

  # darwin currently lacks a pure `pgrep` which is extensively used here
  doCheck = !stdenv.isDarwin;
  nativeCheckInputs = [
    which
    tcl
    ps
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [ getconf ] ++ lib.optionals tlsSupport [ tcltls ];
  checkPhase = ''
    runHook preCheck

    # disable test "Connect multiple replicas at the same time": even
    # upstream find this test too timing-sensitive
    substituteInPlace tests/integration/replication.tcl \
      --replace-fail 'foreach mdl {no yes}' 'foreach mdl {}'

    substituteInPlace tests/support/server.tcl \
      --replace-fail 'exec /usr/bin/env' 'exec env'

    sed -i '/^proc wait_load_handlers_disconnected/{n ; s/wait_for_condition 50 100/wait_for_condition 50 500/; }' \
      tests/support/util.tcl

    patchShebangs ./utils/gen-test-certs.sh
    ${if tlsSupport then "./utils/gen-test-certs.sh" else ""}

    ./runtest \
      --no-latency \
      --timeout 2000 \
      --clients $NIX_BUILD_CORES \
      --tags -leaks ${if tlsSupport then "--tls" else ""}

    runHook postCheck
  '';

  passthru.tests.redis = nixosTests.redis;
  passthru.serverBin = "keydb-server";

  meta = {
    homepage = "https://keydb.dev";
    description = "Multithreaded Fork of Redis";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    changelog = "https://github.com/Snapchat/KeyDB/raw/v${finalAttrs.version}/00-RELEASENOTES";
    maintainers = lib.teams.helsinki-systems.members;
    mainProgram = "keydb-cli";
  };
})
