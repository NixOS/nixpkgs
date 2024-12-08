{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  validatePkgConfig,
  openssl,
  sqlcipher,
  boost,
  curl,
  glib,
  libsecret,
  maddy-markdown,
  testers,
  nix-update-script,
  withLibsecret ? stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isDarwin,
}:
assert lib.assertMsg (
  (!withLibsecret) -> stdenv.hostPlatform.isDarwin
) "libsecret is only optional on Darwin";

stdenv.mkDerivation (finalAttrs: {
  pname = "libnick";
  version = "2024.11.1";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "libnick";
    rev = "${finalAttrs.version}";
    hash = "sha256-e64f8zG+/kV4BmG76UZAhDJL6IeDMbdXwyHgjYiSJtU=";
  };

  nativeBuildInputs =
    [
      cmake
      ninja
    ]
    ++ lib.optionals stdenv.hostPlatform.isUnix [
      pkg-config
      validatePkgConfig
    ];

  buildInputs =
    [
      boost
      maddy-markdown
    ]
    ++ lib.optionals stdenv.hostPlatform.isUnix [
      glib
      openssl
    ]
    ++ lib.optional stdenv.hostPlatform.isWindows sqlcipher;

  propagatedBuildInputs = [
    curl
  ] ++ lib.optional withLibsecret libsecret;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "USE_LIBSECRET" withLibsecret)
  ];

  postPatch = ''
    substituteInPlace cmake/libnick.pc.in \
    --replace-fail 'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR' \
    --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' 'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR'
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross-platform development base for native Nickvision applications";
    homepage = "https://github.com/NickvisionApps/libnick";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      normalcea
      getchoo
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [ "libnick" ];
  };
})
