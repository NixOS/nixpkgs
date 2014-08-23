{ stdenv, fetchurl, pkgconfig
, gtk2, alsaLib
, fftw, gsl
}:

stdenv.mkDerivation rec {
  name = "snd-14.3";

  meta = {
    description = "Sound editor";
    homepage = http://ccrma.stanford.edu/software/snd;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "mirror://sourceforge/snd/${name}.tar.gz";
    sha256 = "04shk34pza507kvm40dc6sdz5jz533z4q2h7m9hgqvw1r3f57ms6";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    gtk2 alsaLib
    fftw gsl
  ];
}
