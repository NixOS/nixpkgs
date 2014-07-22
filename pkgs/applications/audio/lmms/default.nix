{ stdenv, fetchurl, SDL, alsaLib, cmake, fftwSinglePrec, jack2, libogg
, libsamplerate, libsndfile, pkgconfig, pulseaudio, qt4
}:

stdenv.mkDerivation  rec {
  name = "lmms-${version}";
  version = "0.4.15";

  src = fetchurl {
    url = "mirror://sourceforge/lmms/${name}.tar.bz2";
    sha256 = "02q2gbsqwk3hf9kvzz58a5bxmlb4cfr2mzy41wdvbxxdm2pcl101";
  };

  buildInputs = [
    SDL alsaLib cmake fftwSinglePrec jack2 libogg libsamplerate
    libsndfile pkgconfig pulseaudio qt4
  ];

  meta = with stdenv.lib; {
    description = "Linux MultiMedia Studio";
    homepage = "http://lmms.sourceforge.net";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
