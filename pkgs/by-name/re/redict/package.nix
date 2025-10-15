{
  lib,
  stdenv,
  fetchFromGitea,
  fetchurl,
  lua,
  jemalloc,
  pkg-config,
  tcl,
  which,
  ps,
  getconf,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  # dependency ordering is broken at the moment when building with openssl
  tlsSupport ? !stdenv.hostPlatform.isStatic,
  openssl,

  # Using system jemalloc fixes cross-compilation and various setups.
  # However the experimental 'active defragmentation' feature of redict requires
  # their custom patched version of jemalloc.
  useSystemJemalloc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redict";
  version = "7.3.6";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "redict";
    repo = "redict";
    tag = finalAttrs.version;
    hash = "sha256-ye2uO6EQzfyonRvM0/+pVPoNZe2f9WO/2yafy52G10M=";
  };

  patches = lib.optionals useSystemJemalloc [
    # use system jemalloc
    (fetchurl {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/redis/-/raw/102cc861713c796756abd541bf341a4512eb06e6/redis-5.0-use-system-jemalloc.patch";
      hash = "sha256-VPRfoSnctkkkzLrXEWQX3Lh5HmZaCXoJafyOG007KzM=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    lua
  ]
  ++ lib.optional useSystemJemalloc jemalloc
  ++ lib.optional withSystemd systemd
  ++ lib.optionals tlsSupport [ openssl ];

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/Makefile --replace-fail "-flto" ""
  '';

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

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [ "-std=c11" ]);

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
      --replace-fail "foreach mdl {no yes}" "foreach mdl {}"

    substituteInPlace tests/support/server.tcl \
      --replace-fail "exec /usr/bin/env" "exec env"

    sed -i '/^proc wait_load_handlers_disconnected/{n ; s/wait_for_condition 50 100/wait_for_condition 50 500/; }' \
      tests/support/util.tcl

    ./runtest \
      --no-latency \
      --timeout 2000 \
      --clients $NIX_BUILD_CORES \
      --tags -leaks \
      --skipunit integration/failover \
      --skipunit integration/aof-multi-part

    runHook postCheck
  '';

  meta = {
    homepage = "https://redict.io";
    description = "Distributed key/value store";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.all;
    changelog = "https://codeberg.org/redict/redict/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ yuka ];
    mainProgram = "redict-cli";
  };
})
