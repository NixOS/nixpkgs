{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libpng,
  libtiff,
  zlib,
  lcms2,
  jpylyzer,
  jpipLibSupport ? false, # JPIP library & executables
  jpipServerSupport ? false,
  curl,
  fcgi, # JPIP Server
  jdk,

  # for passthru.tests
  ffmpeg,
  gdal,
  gdcm,
  ghostscript,
  imagemagick,
  leptonica,
  mupdf,
  poppler,
  python3,
  vips,
}:

let
  mkFlag = optSet: flag: "-D${flag}=${if optSet then "ON" else "OFF"}";
in

stdenv.mkDerivation rec {
  pname = "openjpeg";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg";
    rev = "v${version}";
    hash = "sha256-mQ9B3MJY2/bg0yY/7jUJrAXM6ozAHT5fmwES5Q1SGxw=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/uclouvain/openjpeg/issues/1564
      name = "CVE-2024-56826_ISSUE1564.patch";
      url = "https://github.com/uclouvain/openjpeg/commit/e492644fbded4c820ca55b5e50e598d346e850e8.patch";
      hash = "sha256-v+odu4/MXRA+RKOlPO+m/Xk66BMH6mOcEN4ScHn3VAo=";
    })
    (fetchpatch {
      # https://github.com/uclouvain/openjpeg/issues/1563
      name = "CVE-2024-56826_ISSUE1563.patch";
      url = "https://github.com/uclouvain/openjpeg/commit/98592ee6d6904f1b48e8207238779b89a63befa2.patch";
      hash = "sha256-1ScnEZAPuvclyRME5kbeo7dBMG31Njs5CaYC4sGyx08=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_NAME_DIR=\${CMAKE_INSTALL_PREFIX}/lib"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_CODEC=ON"
    "-DBUILD_THIRDPARTY=OFF"
    (mkFlag jpipLibSupport "BUILD_JPIP")
    (mkFlag jpipServerSupport "BUILD_JPIP_SERVER")
    "-DBUILD_VIEWER=OFF"
    "-DBUILD_JAVA=OFF"
    (mkFlag doCheck "BUILD_TESTING")
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      libpng
      libtiff
      zlib
      lcms2
    ]
    ++ lib.optionals jpipServerSupport [
      curl
      fcgi
    ]
    ++ lib.optional (jpipLibSupport) jdk;

  doCheck = (!stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isPower64); # tests fail on aarch64-linux and powerpc64
  nativeCheckInputs = [ jpylyzer ];
  checkPhase = ''
    substituteInPlace ../tools/ctest_scripts/travis-ci.cmake \
      --replace "JPYLYZER_EXECUTABLE=" "JPYLYZER_EXECUTABLE=\"$(command -v jpylyzer)\" # "
    OPJ_SOURCE_DIR=.. ctest -S ../tools/ctest_scripts/travis-ci.cmake
  '';

  passthru = {
    incDir = "openjpeg-${lib.versions.majorMinor version}";
    tests = {
      ffmpeg = ffmpeg.override { withOpenjpeg = true; };
      imagemagick = imagemagick.override { openjpegSupport = true; };
      pillow = python3.pkgs.pillow;

      inherit
        gdal
        gdcm
        ghostscript
        leptonica
        mupdf
        poppler
        vips
        ;
    };
  };

  meta = with lib; {
    description = "Open-source JPEG 2000 codec written in C language";
    homepage = "https://www.openjpeg.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
    changelog = "https://github.com/uclouvain/openjpeg/blob/v${version}/CHANGELOG.md";
  };
}
