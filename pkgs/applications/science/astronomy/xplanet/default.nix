{stdenv, fetchurl, pkgconfig, freetype, pango, libpng, libtiff, giflib
, libjpeg, netpbm}:

stdenv.mkDerivation rec {
  name = "xplanet-1.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/xplanet/${name}.tar.gz";
    sha256 = "0hml2v228wi2r61m1pgka7h96rl92b6apk0iigm62miyp4mp9ys4";
  };

  buildInputs = [ pkgconfig freetype pango libpng libtiff giflib libjpeg netpbm ];

  meta = {
    description = "Renders an image of the earth or other planets into the X root window";
    homepage = http://xplanet.sourceforge.net;
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
