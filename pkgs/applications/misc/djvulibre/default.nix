args: with args;

stdenv.mkDerivation {
  name = "djvulibre-3.5.22";

  src = fetchurl {
    url = mirror://sourceforge/djvu/djvulibre-3.5.22.tar.gz;
    sha256 = "1gphi67qiq1ky7k8vymkwcgla80cwy8smk1rla6grxdqipwl54ix";
  };

  buildInputs = [qt libX11 libjpeg libtiff libpng ghostscript zlib libungif x11 mesa];

  meta = {
    description = "A library and viewer for the DJVU file format for scanned images";
    homepage = http://djvu.sourceforge.net;
  };
}
