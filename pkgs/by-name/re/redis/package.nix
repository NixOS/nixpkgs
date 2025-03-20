{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  tlsSupport ? true,
  # Using system jemalloc fixes cross-compilation and various setups.
  # However the experimental 'active defragmentation' feature of redis requires
  # their custom patched version of jemalloc.
  useSystemJemalloc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redis";
  version = "7.2.7";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "redis";
    rev = finalAttrs.version;
    hash = "sha256-WZ89BUm3zz6n0dZKyODHCyMGExbqaPJJ1qxLvJKUSDI=";
  };

  patches = lib.optional useSystemJemalloc (fetchpatch2 {
    url = "https://gitlab.archlinux.org/archlinux/packaging/packages/redis/-/raw/102cc861713c796756abd541bf341a4512eb06e6/redis-5.0-use-system-jemalloc.patch";
    hash = "sha256-A9qp+PWQRuNy/xmv9KLM7/XAyL7Tzkyn0scpVCGngcc=";
  });

  nativeBuildInputs = [
    pkg-config
    which
    python3
  ];

  buildInputs =
    [ lua ]
    ++ lib.optional useSystemJemalloc jemalloc
    ++ lib.optional withSystemd systemd
    ++ lib.optional tlsSupport openssl;

  # More cross-compiling fixes.
  makeFlags =
    [ "PREFIX=${placeholder "out"}" ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      "AR=${stdenv.cc.targetPrefix}ar"
      "RANLIB=${stdenv.cc.targetPrefix}ranlib"
    ]
    ++ lib.optionals withSystemd [ "USE_SYSTEMD=yes" ]
    ++ lib.optionals tlsSupport [ "BUILD_TLS=yes" ];

  enableParallelBuilding = true;

  hardeningEnable = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "pie" ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [ "-std=c11" ]);
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isFreeBSD "-lexecinfo";

  # darwin currently lacks a pure `pgrep` which is extensively used here
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [
    which
    tcl
    ps
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [ getconf ];
  checkPhase = ''
    runHook preCheck

    # disable test "Connect multiple replicas at the same time": even
    # upstream find this test too timing-sensitive
    substituteInPlace tests/integration/replication.tcl \
      --replace 'foreach mdl {no yes}' 'foreach mdl {}'

    substituteInPlace tests/support/server.tcl \
      --replace 'exec /usr/bin/env' 'exec env'

    sed -i '/^proc wait_load_handlers_disconnected/{n ; s/wait_for_condition 50 100/wait_for_condition 50 500/; }' \
      tests/support/util.tcl

    ./runtest \
      --no-latency \
      --timeout 2000 \
      --clients $NIX_BUILD_CORES \
      --tags -leaks \
      --skipunit integration/aof-multi-part \
      --skipunit integration/failover # flaky and slow

    runHook postCheck
  '';

  passthru.tests.redis = nixosTests.redis;
  passthru.serverBin = "redis-server";

  meta = {
    homepage = "https://redis.io";
    description = "Open source, advanced key-value store";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    changelog = "https://github.com/redis/redis/raw/${finalAttrs.version}/00-RELEASENOTES";
    maintainers = with lib.maintainers; [
      berdario
      globin
    ];
    mainProgram = "redis-cli";
  };
})
