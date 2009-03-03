args: with args;

stdenv.mkDerivation {
  name = "djvulibre-3.5.19";

  src = fetchurl {
    url = mirror://sourceforge/djvu/djvulibre-3.5.19.tar.gz;
    sha256 = "0y6d9ka42llm7h64fc73s4wqcbxg31kallyfaarhkqsxyiaa3zsp";
  };

  buildInputs = [qt libX11 libjpeg libtiff libpng ghostscript zlib libungif x11 mesa];

  meta = {
    description = "A library and viewer for the DJVU file format for scanned images";
    homepage = http://djvu.sourceforge.net;
  };
}
