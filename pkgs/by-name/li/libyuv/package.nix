{
  lib,
  stdenv,
  fetchgit,
  cmake,
  buildPackages,
  libjpeg,
  gtest,
}:

stdenv.mkDerivation {
  pname = "libyuv";
  version = "1908"; # Defined in: include/libyuv/version.h

  src = fetchgit {
    url = "https://chromium.googlesource.com/libyuv/libyuv.git";
    rev = "b7a857659f8485ee3c6769c27a3e74b0af910746"; # upstream does not do tagged releases
    hash = "sha256-4Irs+hlAvr6v5UKXmKHhg4IK3cTWdsFWxt1QTS0rizU=";
  };

  patches = [
    # Fixes wrong byte order in ARGBToRGB565DitherRow_C on big-endian
    ./dither-honour-byte-order.patch
  ];

  nativeBuildInputs = [
    # CMake must run on the build machine in cross builds.
    buildPackages.cmake
  ];

  cmakeFlags = [
    # The unit test binary is huge and can fail to assemble on MinGW
    # ("too many sections"/"file too big"). It's also not runnable in cross builds.
    (lib.cmakeBool "UNIT_TEST" (stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.hostPlatform.isMinGW))
  ];

  buildInputs = [
    libjpeg
  ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.hostPlatform.isMinGW) [
    gtest
  ];

  postPatch = ''
    mkdir -p $out/lib/pkgconfig
    cp ${./yuv.pc} $out/lib/pkgconfig/libyuv.pc

    substituteInPlace $out/lib/pkgconfig/libyuv.pc \
      --replace "@PREFIX@" "$out" \
      --replace "@VERSION@" "$version"
  '';

  # [==========] 3454 tests from 8 test suites ran.
  # [  PASSED  ] 3376 tests.
  # [  FAILED  ] 78 tests
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.hostPlatform.isLoongArch64 && !stdenv.hostPlatform.isMinGW;

  checkPhase = ''
    runHook preCheck

    ./libyuv_unittest

    runHook postCheck
  '';

  meta = {
    homepage = "https://chromium.googlesource.com/libyuv/libyuv";
    description = "Open source project that includes YUV scaling and conversion functionality";
    mainProgram = "yuvconvert";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ leixb ];
    license = lib.licenses.bsd3;
  };
}
