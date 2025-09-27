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
  version = "0-unstable-2025-07-24";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "33ed0be77d7767d0e2010e2c3cf972ef36c7c307";
    hash = "sha256-0rZzbZkOo6DAt1YnH4rtx0FvmCuYH8M6X3DNJ0gURpU=";
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
    # https://github.com/pytorch/cpuinfo/blob/877328f188a3c7d1fa855871a278eb48d530c4c0/CMakeLists.txt#L98
    platforms = lib.platforms.x86 ++ lib.platforms.aarch ++ lib.platforms.riscv;
  };
})
