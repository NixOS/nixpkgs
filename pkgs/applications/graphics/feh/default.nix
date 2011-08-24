{ stdenv, fetchurl, x11, imlib2, libjpeg, libpng, giblib
, libXinerama, curl }:

stdenv.mkDerivation {
  name = "feh-1.14.2";

  src = fetchurl {
    url = http://feh.finalrewind.org/feh-1.14.2.tar.bz2;
    sha256 = "117g1caihil88a3q0qy9gqj521l3illlsk56cgxhpc2am6ch5nwr";
  };

  buildInputs = [x11 imlib2 giblib libjpeg libpng libXinerama curl];

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
