{
  lib,
  stdenv,
  cmake,
  ninja,
  gtest,
  fetchFromGitHub,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhwy";
  version = "1.4.0";

  __structuredAttrs = true;
  outputs = [
    "out"
    "dev"
    "contrib"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    tag = finalAttrs.version;
    hash = "sha256-YUYZO9KLffczjwIz3mBBceD6oM1giLCFLDHgDCevdRA=";
  };

  patches = [
    ./move-contrib-to-its-own-output.patch
  ];

  hardeningDisable = lib.optionals stdenv.hostPlatform.isAarch64 [
    # aarch64-specific code gets:
    # __builtin_clear_padding not supported for variable length aggregates
    "trivialautovarinit"
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  checkInputs = [
    gtest
  ];

  # Required for case-insensitive filesystems ("BUILD" exists)
  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_CONTRIB_PREFIX=${placeholder "contrib"}"
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "HWY_ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optional finalAttrs.finalPackage.doCheck (lib.cmakeBool "HWY_SYSTEM_GTEST" true)
  ++ lib.optionals stdenv.hostPlatform.isAarch32 [
    "-DHWY_CMAKE_ARM7=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_32 [
    # Quoting CMakelists.txt:
    #   This must be set on 32-bit x86 with GCC < 13.1, otherwise math_test will be
    #   skipped. For GCC 13.1+, you can also build with -fexcess-precision=standard.
    # Fixes tests:
    #   HwyMathTestGroup/HwyMathTest.TestAllAtanh/EMU128
    #   HwyMathTestGroup/HwyMathTest.TestAllLog1p/EMU128
    "-DHWY_CMAKE_SSE2=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isRiscV [
    # Runtime dispatch is not implemented https://github.com/google/highway/issues/838
    # so tests (and likely normal operation) fail with SIGILL on processors without V.
    # Until the issue is resolved, we disable RVV completely.
    "-DHWY_CMAKE_RVV=OFF"
  ];

  # Consumers rely on test headers being exported, but CMake install them only when tests are enabled.
  postInstall = lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    install -Dm644 hwy/tests/*.h -t $out/include/hwy/tests/
  '';

  # hydra's darwin machines run into https://github.com/libjxl/libjxl/issues/408
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Performance-portable, length-agnostic SIMD with runtime dispatch";
    homepage = "https://github.com/google/highway";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ zhaofengli ];
    pkgConfigModules = [
      "libhwy"
      "libhwy-contrib"
    ];
  };
})
