{ stdenv, fetchurl, lib, useQt3 ? false, libjpeg, libtiff, libpng, ghostscript
, libungif, zlib, x11, libX11, mesa, qt3 }:

stdenv.mkDerivation rec {
  name = "djvulibre-3.5.24";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${name}.tar.gz";
    sha256 = "0d1592cmc7scg2jzah47mnvbqldhxb1x9vxm7y64a3iasa0lqwy0";
  };

  buildInputs = [ libjpeg libtiff libpng ghostscript zlib libungif ] ++
    stdenv.lib.optionals useQt3 [qt3 libX11 x11 mesa];

  meta = {
    description = "A library and viewer for the DJVU file format for scanned images";
    homepage = http://djvu.sourceforge.net;
    maintainers = [ lib.maintainers.urkud ];
  };
}
