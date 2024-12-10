{
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  stdenv,
  gtest,
  nix-update-script,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cpuinfo";
  version = "0-unstable-2024-11-14";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "cebb0933058d7f181c979afd50601dc311e1bf8c";
    hash = "sha256-MlJZmgwHt6+hJHdl8lKOTeaTT+PTOgRHfmCCjn0a3Zc=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeBool "CPUINFO_BUILD_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "CPUINFO_BUILD_MOCK_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "CPUINFO_BUILD_BENCHMARKS" false)
    (lib.cmakeBool "USE_SYSTEM_LIBS" true)
  ];

  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);

  meta = {
    description = "Tools and library to detect essential for performance optimization information about host CPU";
    homepage = "https://github.com/pytorch/cpuinfo";
    license = lib.licenses.bsd2;
    mainProgram = "cpu-info";
    maintainers = with lib.maintainers; [ pawelchcki ];
    pkgConfigModules = [ "libcpuinfo" ];
    platforms = lib.platforms.all;
  };
})
