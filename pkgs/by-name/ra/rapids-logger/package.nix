{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  rapids-cmake,
  spdlog,
  gtest,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapids-logger";
  version = "0.2.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rapidsai";
    repo = "rapids-logger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yRvO/+SCJThzYvYrt0ZudJojFUfO21OlEIy5G4HjtJ0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    rapids-cmake
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CPM_spdlog_SOURCE" spdlog.src.outPath)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CPM_GTest_SOURCE" gtest.src.outPath)
  ];

  doCheck = true;

  passthru.tests.cmake-config = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    description = "ABI-stable logging library for RAPIDS, wrapping spdlog";
    homepage = "https://github.com/rapidsai/rapids-logger";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    cmakeConfigModules = [ "rapids_logger" ];
    platforms = lib.platforms.linux;
  };
})
