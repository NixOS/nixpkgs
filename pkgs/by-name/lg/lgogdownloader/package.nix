{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  pkg-config,
  curl,
  html-tidy,
  jsoncpp,
  ninja,
  pkg-config,
  rhash,
  tinyxml-2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgogdownloader";
  version = "3.19";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4JHV2m5zSekWYpO0j3weH5hiG/kmciDF4Jby46ykxCI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    curl
    html-tidy
    jsoncpp
    liboauth
    rhash
    tinyxml-2
    zlib
  ];

  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "lgogdownloader";
    homepage = "https://github.com/Sude-/lgogdownloader";
    license = lib.licenses.wtfpl;
    # qtbase requires a sandbox profile with read access to /usr/share/icu.
    # To prevent build failures in CI, we disable Darwin support when the GUI is enabled.
    platforms = lib.platforms.linux ++ lib.optionals (!enableGui) lib.platforms.darwin;
    maintainers = with lib.maintainers; [ _0x4A6F ];
  };
})
