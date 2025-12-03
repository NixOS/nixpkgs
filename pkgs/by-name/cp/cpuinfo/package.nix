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
  version = "0-unstable-2025-11-19";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "161a9ec374884f4b3e85725cb22e05f9458fdc93";
    hash = "sha256-uzo6QpNfzTcqOpDse14e2OoxNyKDU8jSx+/wPLxmpJg=";
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
    # https://github.com/pytorch/cpuinfo/blob/161a9ec374884f4b3e85725cb22e05f9458fdc93/CMakeLists.txt#L98
    platforms = lib.platforms.x86 ++ lib.platforms.aarch ++ lib.platforms.riscv;
  };
})
