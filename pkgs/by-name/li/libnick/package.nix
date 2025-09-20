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
  cpr,
  curl,
  glib,
  libsecret,
  libmaddy-markdown,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnick";
  version = "2025.9.2";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "libnick";
    tag = finalAttrs.version;
    hash = "sha256-Trz1SQxv/VplAKHO62aGxHb8k9KSUSReH+hYLaUagUY=";
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isUnix [
    glib
    openssl
  ];

  propagatedBuildInputs = [
    curl
    cpr
    libsecret
    libmaddy-markdown
    sqlcipher
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
