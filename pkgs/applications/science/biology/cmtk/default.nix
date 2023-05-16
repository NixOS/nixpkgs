<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "cmtk";
  version = "3.3.1";

  src = fetchurl {
    name = "cmtk-source.tar.gz";
    url = "https://www.nitrc.org/frs/download.php/8198/CMTK-${version}-Source.tar.gz//?i_agree=1&download_now=1";
    sha256 = "1nmsga9m7vcc4y4a6zl53ra3mwlgjwdgsq1j291awkn7zr1az6qs";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

<<<<<<< HEAD
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
=======
  env.NIX_CFLAGS_COMPILE = toString [
    "-std=c++11"
    (lib.optional stdenv.cc.isClang "-Wno-error=c++11-narrowing")
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Computational Morphometry Toolkit ";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''A software toolkit for computational morphometry of
      biomedical images, CMTK comprises a set of command line tools and a
      back-end general-purpose library for processing and I/O'';
    maintainers = with maintainers; [ tbenst ];
    platforms = platforms.all;
<<<<<<< HEAD
    license = licenses.gpl3Plus;
    homepage = "https://www.nitrc.org/projects/cmtk/";
  };
})
=======
    license = licenses.gpl3;
    homepage = "https://www.nitrc.org/projects/cmtk/";
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
