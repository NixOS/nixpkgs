{
  lib,
  stdenv,
  fetchFromGitHub,

  # build
  libtool,
  bison,
  meson,
  ninja,
  flex,

  # runtime
  lksctp-tools,
  vectorscan,
  libxcrypt,
  openssl,
  pkg-config,
  sqlite,
  unstableGitUpdater,
  nixosTests,

  # flags
  withSCTP ? lib.meta.availableOn stdenv.hostPlatform lksctp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solanum";
  version = "0-unstable-2026-09-13";

  src = fetchFromGitHub {
    owner = "solanum-ircd";
    repo = "solanum";
    rev = "96b2cfa1a13a8ad30a6dd85af540cd0f6f74a621";
    hash = "sha256-q1OAi6pEpmuc4G2PiiEBPBANKIkg7tvFw/jJigxTRH0=";
  };

  postPatch = ''
    substituteInPlace include/defaults.h \
      --replace-fail 'ETCPATH "' '"/etc/solanum'

    # fhs path touching in the build sandbox breaks
    sed -i "/install_emptydir/d" meson.build
  '';

  mesonBuildType = "debugoptimized";
  mesonFlags = [
    # (lib.mesonOption "custom_version" finalAttrs.src.rev)
    (lib.mesonBool "fhs_paths" true)
    (lib.mesonOption "localstatedir" "/var")
    (lib.mesonOption "logdir" "/var/log")
    (lib.mesonOption "rundir" "/run")
    (lib.mesonEnable "mbedtls" false)
    (lib.mesonEnable "openssl" true)
    (lib.mesonEnable "gnutls" false)
    (lib.mesonEnable "sctp" withSCTP)
  ];

  nativeBuildInputs = [
    bison
    flex
    libtool
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libxcrypt
    openssl
    sqlite
    vectorscan
  ]
  ++ lib.optionals withSCTP [
    lksctp-tools
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  enableParallelBuilding = true;

  passthru = {
    tests = { inherit (nixosTests) solanum; };
    updateScript = unstableGitUpdater { };
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "IRCd for unified networks";
    homepage = "https://github.com/solanum-ircd/solanum";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "solanum";
    platforms = lib.platforms.unix;
  };
})
