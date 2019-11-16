{ stdenv, fetchurl, libogg }:

stdenv.mkDerivation rec {
  name = "flac-1.3.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/flac/${name}.tar.xz";
    sha256 = "0j0p9sf56a2fm2hkjnf7x3py5ir49jyavg4q5zdyd7bcf6yq4gi1";
  };

  buildInputs = [ libogg ];

  #doCheck = true; # takes lots of time

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  meta = with stdenv.lib; {
    homepage = https://xiph.org/flac/;
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
