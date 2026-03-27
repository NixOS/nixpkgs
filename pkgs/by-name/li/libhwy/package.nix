{
  lib,
  stdenv,
  cmake,
  ninja,
  gtest,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "libhwy";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = version;
    hash = "sha256-8QOk96Y3GIIvBUGIDikMgTylx8y5aCyr68/TP5w5ha4=";
  };

  patches = [
    # Apply upstream workaround for gcc-15 bug:
    #   https://github.com/google/highway/issues/2813
    #   https://github.com/google/highway/pull/2824
    (fetchpatch {
      name = "gcc-15-clone-hack-prerequisite.patch";
      url = "https://github.com/google/highway/commit/3b680cde3a556bead9cc23c8f595d07a44d5a0d5.patch";
      hash = "sha256-8xBPuhsifalhzKgeEOQq6yZw2NWas+SFQrNIaMicRnY=";
    })
    (fetchpatch {
      name = "gcc-15-clone-hack.patch";
      url = "https://github.com/google/highway/commit/5af21b8a9078330a3d7456d855e69245bb87bc7a.patch";
      hash = "sha256-hC/oEdxHsdZKlLFIw929ZHjffPURGzk9jiKz6iGSLkY=";
    })
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

  # Required for case-insensitive filesystems ("BUILD" exists)
  dontUseCmakeBuildDir = true;

  cmakeFlags =
    let
      libExt = stdenv.hostPlatform.extensions.library;
    in
    [
      "-GNinja"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ]
    ++ lib.optionals doCheck [
      "-DHWY_SYSTEM_GTEST:BOOL=ON"
      "-DGTEST_INCLUDE_DIR=${lib.getDev gtest}/include"
      "-DGTEST_LIBRARY=${lib.getLib gtest}/lib/libgtest${libExt}"
      "-DGTEST_MAIN_LIBRARY=${lib.getLib gtest}/lib/libgtest_main${libExt}"
    ]
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

  # hydra's darwin machines run into https://github.com/libjxl/libjxl/issues/408
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Performance-portable, length-agnostic SIMD with runtime dispatch";
    homepage = "https://github.com/google/highway";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
