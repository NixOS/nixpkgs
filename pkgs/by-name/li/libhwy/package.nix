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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = version;
    hash = "sha256-yJQH5ZkpEdJ6lsTAt6yJSN3TQnVoxNpkbChENaxhcHo=";
  };

  patches = [
    (fetchpatch {
      name = "disable-RVV-runtime-dispatch.patch";
      url = "https://github.com/google/highway/commit/c95cc0237d2f7a0f5ca5dc3fb4b5961b2b1dcdfc.patch";
      hash = "sha256-oQfyZrjZ9MGcSrFInbbj+0iOLjPng7tgTzli1QTITSg=";
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

  meta = with lib; {
    description = "Performance-portable, length-agnostic SIMD with runtime dispatch";
    homepage = "https://github.com/google/highway";
    license = with licenses; [
      asl20
      bsd3
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
