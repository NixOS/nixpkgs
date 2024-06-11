{ lib
, stdenv
, bzip2
, cmake
, fetchurl
, fftw
, llvmPackages
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmtk";
  version = "3.3.2";

  src = fetchurl {
    name = "cmtk-source.tar.gz";
    url = "https://www.nitrc.org/frs/download.php/13188/CMTK-${finalAttrs.version}-Source.tar.gz//?i_agree=1&download_now=1";
    hash = "sha256-iE164NCOSOypZLLZfZy9RTyrS+YnY9ECqfb4QhlsMS4=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    bzip2
    fftw
    zlib
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    (lib.optionalString stdenv.cc.isGNU "-std=c++11")
    (lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing")
    (lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) "-Dfinite=isfinite")
  ];

  meta = with lib; {
    description = "Computational Morphometry Toolkit";
    mainProgram = "cmtk";
    longDescription = ''A software toolkit for computational morphometry of
      biomedical images, CMTK comprises a set of command line tools and a
      back-end general-purpose library for processing and I/O'';
    maintainers = with maintainers; [ tbenst ];
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    homepage = "https://www.nitrc.org/projects/cmtk/";
  };
})
