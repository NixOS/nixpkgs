{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "soxr-0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/soxr/${name}-Source.tar.xz";
    sha256 = "0xf2w3piwz9gfr1xqyrj4k685q5dy53kq3igv663i4f4y4sg9rjl";
  };

  preConfigure = if stdenv.isDarwin then ''
    export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:"`pwd`/build/src
  '' else ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:"`pwd`/build/src
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ (stdenv.cc.cc.lib or null) ];
  # outputs TODO: gcc.lib might become a problem;
  # here -out/lib/*.a got found and -lib/lib/*.so didn't

  meta = {
    description = "An audio resampling library";
    homepage = http://soxr.sourceforge.net;
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
