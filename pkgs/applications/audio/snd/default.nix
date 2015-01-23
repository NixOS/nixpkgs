{ stdenv, fetchurl, pkgconfig
, gtk2, alsaLib
, fftw, gsl
}:

stdenv.mkDerivation rec {
  name = "snd-15.2";

  src = fetchurl {
    url = "mirror://sourceforge/snd/${name}.tar.gz";
    sha256 = "0v2r7a6363aai726cywi7ai0qlwdc20bqdprs5fmyz8sbmksbqzr";
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
