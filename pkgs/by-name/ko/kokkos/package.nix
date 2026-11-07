{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  python3,
  rocmSupport ? false,
  rocmPackages,
  # Kokkos builds for exactly one AMD GPU: the wavefront size of that target is
  # baked into the installed headers.
  hipTarget ? "gfx908",
}:

let
  stdenv' = if rocmSupport then rocmPackages.stdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "kokkos";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "kokkos";
    repo = "kokkos";
    rev = finalAttrs.version;
    hash = "sha256-ua72Ur01RhV8nTxcb1W8SaL41NIJxDfa9QhOQp1fHZQ=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  # Exported through KokkosConfig.cmake (hip::host and the rocThrust TPL)
  propagatedBuildInputs = lib.optionals rocmSupport [
    rocmPackages.clr
    rocmPackages.rocprim
    rocmPackages.rocthrust
  ];

  cmakeFlags = [
    # Tests need a GPU to run with the HIP backend
    (lib.cmakeBool "Kokkos_ENABLE_TESTS" (!rocmSupport))
  ]
  ++ lib.optionals rocmSupport [
    # Consumers must share a single Kokkos runtime
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "Kokkos_ENABLE_HIP" true)
    (lib.cmakeBool "Kokkos_ENABLE_COMPILE_AS_CMAKE_LANGUAGE" true)
    (lib.cmakeBool "Kokkos_ARCH_AMD_${lib.toUpper hipTarget}" true)
    (lib.cmakeFeature "CMAKE_HIP_COMPILER" "${rocmPackages.clr.hipClangPath}/clang++")
    (lib.cmakeFeature "CMAKE_HIP_COMPILER_ROCM_ROOT" "${rocmPackages.clr}")
    (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" hipTarget)
  ];

  postPatch = ''
    patchShebangs .
  '';

  doCheck = !rocmSupport;
  passthru = {
    inherit rocmSupport rocmPackages hipTarget;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "C++ Performance Portability Programming EcoSystem";
    homepage = "https://github.com/kokkos/kokkos";
    changelog = "https://github.com/kokkos/kokkos/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
