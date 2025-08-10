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
  libmaddy-markdown,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnick";
  version = "2025.6.1";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "libnick";
    tag = finalAttrs.version;
    hash = "sha256-Ir2Jke1zK4pKldQJHaT0Ju0ubz7H6nx16hDNl6u48Ck=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isUnix [
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    boost
    libmaddy-markdown
  ]
  ++ lib.optionals stdenv.hostPlatform.isUnix [
    glib
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isWindows sqlcipher;

  propagatedBuildInputs = [
    curl
    libsecret
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "USE_LIBSECRET" "true")
  ];

  postPatch = ''
    substituteInPlace cmake/libnick.pc.in \
    --replace-fail 'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' \
                   'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
    --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' \
                   'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross-platform development base for native Nickvision applications";
    homepage = "https://github.com/NickvisionApps/libnick";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.normalcea ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [ "libnick" ];
  };
})
