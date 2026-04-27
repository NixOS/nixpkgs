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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solanum";
  version = "0-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "solanum-ircd";
    repo = "solanum";
    rev = "54286cf59235c8688104ee20d4e1d74fe8934317";
    hash = "sha256-0som1lYheX/GVbqwEXwpIWonYKYqFwpAfcRRojlHlmc=";
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
    libxcrypt
    openssl
    sqlite
    vectorscan
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
    mainProgram = "solanum";
    platforms = lib.platforms.unix;
  };
})
