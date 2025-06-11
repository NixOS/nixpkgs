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
  version = "0-unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "39ea79a3c132f4e678695c579ea9353d2bd29968";
    hash = "sha256-uochXC0AtOw8N/ycyVJdiRw4pibCW2ENrFMT3jtxDSg=";
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

  # The tests check what CPU the host has and makes sure it can query information.
  # not all build environments may have this information available. And, cpuinfo may
  # not understand all CPUs (causing test failures such as https://github.com/pytorch/cpuinfo/issues/132)
  # Instead, allow building in any environment.
  doCheck = false;

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
