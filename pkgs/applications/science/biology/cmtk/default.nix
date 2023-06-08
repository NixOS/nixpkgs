{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "cmtk";
  version = "3.3.2";

  src = fetchurl {
    name = "cmtk-source.tar.gz";
    url = "https://www.nitrc.org/frs/download.php/13188/CMTK-${version}-Source.tar.gz//?i_agree=1&download_now=1";
    hash = "sha256-iE164NCOSOypZLLZfZy9RTyrS+YnY9ECqfb4QhlsMS4=";
  };

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-std=c++11"
    (lib.optional stdenv.cc.isClang "-Wno-error=c++11-narrowing")
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Computational Morphometry Toolkit ";
    longDescription = ''A software toolkit for computational morphometry of
      biomedical images, CMTK comprises a set of command line tools and a
      back-end general-purpose library for processing and I/O'';
    maintainers = with maintainers; [ tbenst ];
    platforms = platforms.all;
    license = licenses.gpl3;
    homepage = "https://www.nitrc.org/projects/cmtk/";
  };
}
