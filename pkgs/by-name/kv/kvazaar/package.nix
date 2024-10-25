{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  testers,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kvazaar";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "ultravideo";
    repo = "kvazaar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d/OkX18nyHSQXJgNhBtiCLb/Fe8Y/MpddXxLpNMZiXI=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Open-source HEVC encoder";
    homepage = "https://github.com/ultravideo/kvazaar";
    changelog = "https://github.com/ultravideo/kvazaar/releases/tag/v${finalAttrs.version}";
    pkgConfigModules = [ "kvazaar" ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
