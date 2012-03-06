{ stdenv, fetchurl, libjpeg, libtiff, libpng, ghostscript, libungif, zlib }:

stdenv.mkDerivation rec {
  name = "djvulibre-3.5.24";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${name}.tar.gz";
    sha256 = "0d1592cmc7scg2jzah47mnvbqldhxb1x9vxm7y64a3iasa0lqwy0";
  };

  buildInputs = [ libjpeg libtiff libpng ghostscript zlib libungif ];

  patches = [ ./gcc-4.6.patch ];

  meta = {
    description = "A library and viewer for the DJVU file format for scanned images";
    homepage = http://djvu.sourceforge.net;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
