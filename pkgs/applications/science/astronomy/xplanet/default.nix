{stdenv, fetchurl, pkgconfig, freetype, pango, libpng, libtiff, giflib
, libjpeg, netpbm}:

stdenv.mkDerivation rec {
  name = "xplanet-1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/xplanet/${name}.tar.gz";
    sha256 = "1jnkrly9njkibxqbg5im4pq9cqjzwmki6jzd318dvlfmnicqr3vg";
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
