{ stdenv, fetchurl, libjpeg, libtiff, librsvg }:

stdenv.mkDerivation rec {
  name = "djvulibre-3.5.25.3";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${name}.tar.gz";
    sha256 = "1q5i5ha4zmj2ahjfhi8cv1rah80vm43m9ads46ji38rgvpb7x3c9";
  };

  buildInputs = [ libjpeg libtiff librsvg ];

  meta = {
    description = "A library and viewer for the DJVU file format for scanned images";
    homepage = http://djvu.sourceforge.net;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
