{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "fontmatrix-0.6.0";
  src = fetchurl {
    url = "http://fontmatrix.be/archives/${name}-Source.tar.gz";
    sha256 = "bcc5e929d95d2a0c9481d185144095c4e660255220a7ae6640298163ee77042c";
  };

  buildInputs = [ qt4 ];

  nativeBuildInputs = [ cmake ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Fontmatrix is a free/libre font explorer for Linux, Windows and Mac";
    homepage = http://fontmatrix.be/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
