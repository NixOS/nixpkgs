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
  # may need to get updated with package
  # https://github.com/uclouvain/openjpeg-data
  test-data = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg-data";
    rev = "39524bd3a601d90ed8e0177559400d23945f96a9";
    hash = "sha256-ckZHCZV5UJicVUoi/mZDwvCJneXC3X+NA8Byp6GLE0w=";
  };
in
stdenv.mkDerivation rec {
  pname = "openjpeg";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg";
    rev = "v${version}";
    hash = "sha256-HSXGdpHUbwlYy5a+zKpcLo2d+b507Qf5nsaMghVBlZ8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    "-DBUILD_CODEC=ON"
    "-DBUILD_THIRDPARTY=OFF"
    (lib.cmakeBool "BUILD_JPIP" jpipLibSupport)
    (lib.cmakeBool "BUILD_JPIP_SERVER" jpipServerSupport)
    "-DBUILD_VIEWER=OFF"
    "-DBUILD_JAVA=OFF"
    (lib.cmakeBool "BUILD_TESTING" doCheck)
  ]
  ++ lib.optional doCheck "-DOPJ_DATA_ROOT=${test-data}";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libpng
    libtiff
    zlib
    lcms2
  ]
  ++ lib.optionals jpipServerSupport [
    curl
    fcgi
  ]
  ++ lib.optional jpipLibSupport jdk;

  # tests did fail on powerpc64
  doCheck = !stdenv.hostPlatform.isPower64 && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck
    ctest -j $NIX_BUILD_CORES \
          -E '.*jpylyser' --exclude-from-file ${./exclude-tests}
    runHook postCheck
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

  meta = {
    description = "Open-source JPEG 2000 codec written in C language";
    homepage = "https://www.openjpeg.org/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ codyopel ];
    platforms = lib.platforms.all;
    changelog = "https://github.com/uclouvain/openjpeg/blob/v${version}/CHANGELOG.md";
  };
}
