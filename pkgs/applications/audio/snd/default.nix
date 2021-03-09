{ lib, stdenv, fetchurl, pkg-config
, gtk2, alsaLib
, fftw, gsl
}:

stdenv.mkDerivation rec {
  name = "snd-21.1";

  src = fetchurl {
    url = "mirror://sourceforge/snd/${name}.tar.gz";
    sha256 = "sha256-Y8q9wUEg7mhSDjnFD51NTnItrMzff/obX0bhHfq7u8s=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk2 alsaLib
    fftw gsl
  ];

  meta = {
    description = "Sound editor";
    homepage = "http://ccrma.stanford.edu/software/snd";
    platforms = lib.platforms.linux;
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ ];
  };


}
