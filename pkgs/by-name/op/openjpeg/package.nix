{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, libpng, libtiff, zlib, lcms2
, jpipLibSupport ? false # JPIP library & executables
, jpipServerSupport ? false, curl, fcgi # JPIP Server
, jdk

# for passthru.tests
, ffmpeg
, gdal
, gdcm
, ghostscript
, imagemagick
, leptonica
, mupdf
, poppler
, python3
, vips
}:

let
  # may need to get updated with package
  # https://github.com/uclouvain/openjpeg-data
  test-data = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg-data";
    rev = "a428429db695fccfc6d698bd13b6937dffd9d005";
    hash = "sha256-udUi7sPNQJ5uCIAM8SqMGee6vRj1QbF9pLjdpNTQE5k=";
  };
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

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    "-DBUILD_CODEC=ON"
    "-DBUILD_THIRDPARTY=OFF"
    (lib.cmakeBool "BUILD_JPIP" jpipLibSupport)
    (lib.cmakeBool "BUILD_JPIP_SERVER" jpipServerSupport)
    "-DBUILD_VIEWER=OFF"
    "-DBUILD_JAVA=OFF"
    (lib.cmakeBool "BUILD_TESTING" doCheck)
  ] ++ lib.optional doCheck "-DOPJ_DATA_ROOT=${test-data}";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libpng libtiff zlib lcms2 ]
    ++ lib.optionals jpipServerSupport [ curl fcgi ]
    ++ lib.optional (jpipLibSupport) jdk;

  # tests did fail on powerpc64
  doCheck = !stdenv.hostPlatform.isPower64
    && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

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

  meta = with lib; {
    description = "Open-source JPEG 2000 codec written in C language";
    homepage = "https://www.openjpeg.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
    changelog = "https://github.com/uclouvain/openjpeg/blob/v${version}/CHANGELOG.md";
  };
}
