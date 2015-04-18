{ stdenv, fetchurl, libogg }:

stdenv.mkDerivation rec {
  name = "flac-1.3.1";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/flac/${name}.tar.xz";
    sha256 = "4773c0099dba767d963fd92143263be338c48702172e8754b9bc5103efe1c56c";
  };

  buildInputs = [ libogg ];

  #doCheck = true; # takes lots of time

  outputs = [ "dev" "out" "bin" "doc" ];

  meta = with stdenv.lib; {
    homepage = http://xiph.org/flac/;
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    platforms = platforms.all;
    maintainers = [ maintainers.mornfall ];
  };
}
