{ stdenv, fetchurl, x11, imlib2, libjpeg, libpng, giblib
, libXinerama, curl }:

stdenv.mkDerivation {
  name = "feh-2.4";

  src = fetchurl {
    url = http://feh.finalrewind.org/feh-2.4.tar.bz2;
    sha256 = "00liykp0ipmmiggl26wk72iawcff6zpmbniifdr3f5yf0sfanz48";
  };

  buildInputs = [x11 imlib2 giblib libjpeg libpng libXinerama curl ];

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
