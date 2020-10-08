{ stdenv, fetchurl, pkgconfig
, gtk2, alsaLib
, fftw, gsl
}:

stdenv.mkDerivation rec {
  name = "snd-20.3";

  src = fetchurl {
    url = "mirror://sourceforge/snd/${name}.tar.gz";
    sha256 = "016slh34gb6qqb38m8k9yg48rbhc5p12084szcwvanhh5v7fc7mk";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    gtk2 alsaLib
    fftw gsl
  ];

  meta = {
    description = "Sound editor";
    homepage = "http://ccrma.stanford.edu/software/snd";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [ ];
  };


}
