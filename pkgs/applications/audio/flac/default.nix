{ stdenv, fetchurl, libogg }:

stdenv.mkDerivation rec {
  name = "flac-1.3.0";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/flac/${name}.tar.xz";
    sha256 = "1p0hh190kqvpkbk1bbajd81jfbmkyl4fn2i7pggk2zppq6m68bgs";
  };

  buildInputs = [ libogg ];

  doCheck = true; # takes lots of time but will be run rarely (small build-time closure)

  enableParallelBuilding = true;

  outputs = [ "dev" "out" "bin" "doc" ];

  meta = {
    homepage = http://xiph.org/flac/;
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    platforms = stdenv.lib.platforms.all;
  };
}
