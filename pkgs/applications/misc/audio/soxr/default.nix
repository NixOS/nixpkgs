{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "soxr-0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/soxr/${name}-Source.tar.xz";
    sha256 = "0xf2w3piwz9gfr1xqyrj4k685q5dy53kq3igv663i4f4y4sg9rjl";
  };

  outputs = [ "out" "doc" ]; # headers are just two and very small

  preConfigure = if stdenv.isDarwin then ''
    export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:"`pwd`/build/src
  '' else ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:"`pwd`/build/src
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "An audio resampling library";
    homepage = http://soxr.sourceforge.net;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
