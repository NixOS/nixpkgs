{
  boost,
  cli11,
  cmake,
  doxygen,
  fetchFromGitHub,
  gz-cmake,
  gz-utils,
  gz-math,
  lib,
  libuuid,
  nix-update-script,
  pkg-config,
  python3Minimal,
  stdenv,
  testers,
  tinyxml-2,
  urdfdom,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "sdformat";
  version = "16.1.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "sdformat";
    tag = "sdformat${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-iZ1it91NCJ8xUohp4WyoDfSEYGfp4MWT2DrtYCwjgjs=";
  };

  buildInputs = [
    gz-cmake
    gz-utils
    gz-math
    boost
    cli11
    doxygen
    libuuid
    tinyxml-2
    urdfdom
  ];

  doInstallCheck = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Minimal
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_INTERNAL_URDF" true)
    (lib.cmakeBool "BUILD_TESTING" true)
  ];

  separateDebugInfo = true;

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script {
      attrPath = "sdformat";
    };
    tests.version = testers.testVersion;
  };

  meta = {
    changelog = "https://github.com/gazebosim/sdformat/blob/${finalAttrs.src.tag}/Changelog.md";
    description = "Simulation Description Format (SDF) parser and description files";
    homepage = "http://sdformat.org/";
    downloadPage = "https://github.com/gazebosim/sdformat";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.all;
  };
})
