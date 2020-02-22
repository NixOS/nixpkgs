{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "soxr-0.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/soxr/${name}-Source.tar.xz";
    sha256 = "12aql6svkplxq5fjycar18863hcq84c5kx8g6f4rj0lcvigw24di";
  };

  outputs = [ "out" "doc" ]; # headers are just two and very small

  preConfigure = if stdenv.isDarwin then ''
    export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}"`pwd`/build/src
  '' else ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}"`pwd`/build/src
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "An audio resampling library";
    homepage = http://soxr.sourceforge.net;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
