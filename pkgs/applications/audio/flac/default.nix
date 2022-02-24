{ lib, stdenv, fetchurl, fetchpatch, libogg }:

stdenv.mkDerivation rec {
  pname = "flac";
  version = "1.3.4";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/flac/${pname}-${version}.tar.xz";
    sha256 = "0dz7am8kbc97a6afml1h4yp085274prg8j7csryds8m3fmz61w4g";
  };

  buildInputs = [ libogg ];

  #doCheck = true; # takes lots of time

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  meta = with lib; {
    homepage = "https://xiph.org/flac/";
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
