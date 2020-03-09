{ stdenv, fetchurl, pkgconfig
, gtk2, alsaLib
, fftw, gsl
}:

stdenv.mkDerivation rec {
  name = "snd-20.1";

  src = fetchurl {
    url = "mirror://sourceforge/snd/${name}.tar.gz";
    sha256 = "0v7zhavkkbh1bagzy3l08kb235hhdqn28y0m4znkd3k31p4l4dz8";
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
