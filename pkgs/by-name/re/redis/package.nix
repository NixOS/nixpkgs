{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  apple-sdk,
  lua,
  jemalloc,
  pkg-config,
  nixosTests,
  tcl,
  which,
  ps,
  getconf,
  systemd,
  openssl,
  python3,
  nix-update-script,
  versionCheckHook,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  tlsSupport ? true,
  # Using system jemalloc fixes cross-compilation and various setups.
  # However the experimental 'active defragmentation' feature of redis requires
  # their custom patched version of jemalloc.
  useSystemJemalloc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redis";
  version = "8.6.3";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "redis";
    tag = finalAttrs.version;
    hash = "sha256-Zg2bghU4uExwI1SWplYIGCeGRhgRxdh3Oy9k1DZPado=";
  };

  patches = lib.optional useSystemJemalloc (fetchpatch2 {
    url = "https://gitlab.archlinux.org/archlinux/packaging/packages/redis/-/raw/102cc861713c796756abd541bf341a4512eb06e6/redis-5.0-use-system-jemalloc.patch";
    hash = "sha256-A9qp+PWQRuNy/xmv9KLM7/XAyL7Tzkyn0scpVCGngcc=";
  });

  postPatch = ''
    # Using `yes` seems to be an invalid value and causes the test to fail. See
    # https://github.com/redis/redis/blob/bd3b38d41070b478c58bc8b72d2af89cbccd1a40/redis.conf#L674-L688
    substituteInPlace tests/integration/replication.tcl \
      --replace-fail 'repl-diskless-load yes' ' repl-diskless-load on-empty-db'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # The path `/Library/...` isn't available in the build sandbox. The package `apple-sdk`
    # can provide that functionality for us.
    substituteInPlace src/modules/Makefile modules/vector-sets/Makefile tests/modules/Makefile \
      --replace-fail '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib' \
        '${apple-sdk.sdkroot}/usr/lib'
  '';

  nativeBuildInputs = [
    pkg-config
    which
    python3
  ];

  buildInputs = [
    lua
  ]
  ++ lib.optional useSystemJemalloc jemalloc
  ++ lib.optional withSystemd systemd
  ++ lib.optional tlsSupport openssl;

  # More cross-compiling fixes.
  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "AR=${stdenv.cc.targetPrefix}ar"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
  ]
  ++ lib.optionals withSystemd [ "USE_SYSTEMD=yes" ]
  ++ lib.optionals tlsSupport [ "BUILD_TLS=yes" ];

  enableParallelBuilding = true;

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isFreeBSD "-lexecinfo";

  # darwin currently lacks a pure `pgrep` which is extensively used here
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [
    which
    tcl
    ps
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [ getconf ];
  checkPhase = ''
    runHook preCheck

    # disable test "Connect multiple replicas at the same time": even
    # upstream find this test too timing-sensitive
    substituteInPlace tests/integration/replication.tcl \
      --replace-fail 'foreach sdl {disabled swapdb flushdb} {' 'foreach sdl {} {'

    substituteInPlace tests/support/server.tcl \
      --replace-fail 'exec /usr/bin/env' 'exec env'

    sed -i \
      -e '/^proc wait_load_handlers_disconnected/{n ; s/wait_for_condition 50 100/wait_for_condition 50 500/; }' \
      -e  '/^proc wait_for_ofs_sync/{n ; s/wait_for_condition 50 100/wait_for_condition 50 500/; }' \
      tests/support/util.tcl

    CLIENTS="$NIX_BUILD_CORES"
    if (( $CLIENTS > 4)); then
      CLIENTS=4
    fi

    ./runtest \
      --no-latency \
      --timeout 2000 \
      --clients "$CLIENTS" \
      --tags -leaks \
      --skipunit integration/aof-multi-part \
      --skipunit integration/failover \
      --skipunit integration/replication-rdbchannel \
      --skipunit unit/cluster/atomic-slot-migration \
      --skiptest "Check MEMORY USAGE for embedded key strings with jemalloc"
      # ^ breaks due to unexpected and varying address space sizes that jemalloc gets built with

    runHook postCheck
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/redis-server";

  passthru = {
    tests.redis = nixosTests.redis;
    serverBin = "redis-server";
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://redis.io";
    description = "Open source, advanced key-value store";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    changelog = "https://github.com/redis/redis/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "redis-cli";
  };
})
