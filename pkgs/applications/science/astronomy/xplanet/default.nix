{stdenv, fetchurl, lib, pkgconfig, freetype, pango, libpng, libtiff, giflib, libjpeg}:

stdenv.mkDerivation rec {
  name = "xplanet-1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/xplanet/${name}.tar.gz";
    sha256 = "1jnkrly9njkibxqbg5im4pq9cqjzwmki6jzd318dvlfmnicqr3vg";
  };

  buildInputs = [ pkgconfig freetype pango libpng libtiff giflib libjpeg ];

  meta = {
    description = "Renders an image of the earth or other planets into the X root window";
    homepage = http://xplanet.sourceforge.net;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
