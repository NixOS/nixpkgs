{
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  testers,
  lib,
  cmake,
  ninja,
  pkg-config,
  abseil-cpp_202103,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libilbc";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "TimothyGu";
    repo = "libilbc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GpvHDyvmWPxSt0K5PJQrTso61vGGWHkov7U9/LPrDBU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [ abseil-cpp_202103 ];

  outputs = [
    "out"
    "bin"
    "dev"
    "doc"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Packaged version of iLBC codec from the WebRTC project";
    homepage = "https://github.com/TimothyGu/libilbc";
    changelog = "https://github.com/TimothyGu/libilbc/blob/v${finalAttrs.version}/NEWS.md";
    maintainers = with maintainers; [ jopejoe1 ];
    pkgConfigModules = [ "lilbc" ];
    platforms = platforms.all;
    license = licenses.bsd3;
  };
})
