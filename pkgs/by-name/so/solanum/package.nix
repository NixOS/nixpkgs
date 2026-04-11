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
  hyperscan,
  libxcrypt,
  openssl,
  pkg-config,
  sqlite,
  unstableGitUpdater,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solanum";
  version = "0-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "solanum-ircd";
    repo = "solanum";
    rev = "d8d710c7bc052c3e24f76ca7a63da3a6ba6af8ea";
    hash = "sha256-QnnxRRDou67/PorQ8YzVbQo2E3DF/f+cpR+hVecmyD0=";
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
    hyperscan
    libxcrypt
    openssl
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    lksctp-tools
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  enableParallelBuilding = true;

  passthru = {
    tests = { inherit (nixosTests) solanum; };
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "IRCd for unified networks";
    homepage = "https://github.com/solanum-ircd/solanum";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.unix;
  };
})
