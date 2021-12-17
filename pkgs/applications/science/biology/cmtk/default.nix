{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "cmtk";
  version = "3.3.1";

  src = fetchurl {
    name = "cmtk-source.tar.gz";
    url = "https://www.nitrc.org/frs/download.php/8198/CMTK-${version}-Source.tar.gz//?i_agree=1&download_now=1";
    sha256 = "1nmsga9m7vcc4y4a6zl53ra3mwlgjwdgsq1j291awkn7zr1az6qs";
  };

  nativeBuildInputs = [ cmake ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  meta = with lib; {
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
