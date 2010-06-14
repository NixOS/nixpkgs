{ stdenv, fetchurl, x11, imlib2, libjpeg, libpng, giblib
, libXinerama }:

stdenv.mkDerivation {
  name = "feh-1.6.1";

  src = fetchurl {
    url = http://www.chaosdorf.de/~derf/feh/feh-1.6.1.tar.bz2;
    sha256 = "1mv09b34ar0dx4wl22xak2g554xgpylicqy5zbnk3bh66vn9pxz2";
  };

  buildInputs = [x11 imlib2 giblib libjpeg libpng libXinerama];

  preBuild = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
