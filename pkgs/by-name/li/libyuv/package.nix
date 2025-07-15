{
  lib,
  stdenv,
  fetchgit,
  cmake,
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
    cmake
  ];

  cmakeFlags = [
    "-DUNIT_TEST=ON"
  ];

  buildInputs = [
    libjpeg
    gtest
  ];

  postPatch = ''
    mkdir -p $out/lib/pkgconfig
    cp ${./yuv.pc} $out/lib/pkgconfig/libyuv.pc

    substituteInPlace $out/lib/pkgconfig/libyuv.pc \
      --replace "@PREFIX@" "$out" \
      --replace "@VERSION@" "$version"
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./libyuv_unittest

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://chromium.googlesource.com/libyuv/libyuv";
    description = "Open source project that includes YUV scaling and conversion functionality";
    mainProgram = "yuvconvert";
    platforms = platforms.unix;
    maintainers = with maintainers; [ leixb ];
    license = licenses.bsd3;
  };
}
