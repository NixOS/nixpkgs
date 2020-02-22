{ stdenv, fetchurl, pkgconfig
, gtk2, alsaLib
, fftw, gsl
}:

stdenv.mkDerivation rec {
  name = "snd-20.0";

  src = fetchurl {
    url = "mirror://sourceforge/snd/${name}.tar.gz";
    sha256 = "195j0mkxvkb0znwhc0pjp4r0r8j4i12i27nxbkq27wg9rck6likc";
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
    maintainers = with stdenv.lib.maintainers; [ ];
  };


}
