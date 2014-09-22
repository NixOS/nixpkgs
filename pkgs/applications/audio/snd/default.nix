{ stdenv, fetchurl, pkgconfig
, gtk2, alsaLib
, fftw, gsl
}:

stdenv.mkDerivation rec {
  name = "snd-14.9";

  src = fetchurl {
    url = "mirror://sourceforge/snd/${name}.tar.gz";
    sha256 = "08742smqj6sy8laa1094swcxai5dkk8nvl2dsbvk5n324cb20rh7";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    gtk2 alsaLib
    fftw gsl
  ];

  meta = {
    description = "Sound editor";
    homepage = http://ccrma.stanford.edu/software/snd;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };


}
