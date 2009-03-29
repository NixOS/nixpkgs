args: with args;

stdenv.mkDerivation {
  name = "djvulibre-3.5.21";

  src = fetchurl {
    url = mirror://sourceforge/djvu/djvulibre-3.5.21.tar.gz;
    sha256 = "39f80c1810be22c5ea7f6a44bbb449c3e29902895dcff9da6a8440891a67b8b4";
  };

  buildInputs = [qt libX11 libjpeg libtiff libpng ghostscript zlib libungif x11 mesa];

  meta = {
    description = "A library and viewer for the DJVU file format for scanned images";
    homepage = http://djvu.sourceforge.net;
  };
}
