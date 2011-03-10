{ stdenv, fetchurl, x11, imlib2, libjpeg, libpng, giblib
, libXinerama }:

stdenv.mkDerivation {
  name = "feh-1.11.2";

  src = fetchurl {
    url = http://www.chaosdorf.de/~derf/feh/feh-1.11.1.tar.bz2;
    sha256 = "1rxi0hjp8w1rga48qvq3sgsbsgs4d5q1sq59ld1f7rih1knm2v45";
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
