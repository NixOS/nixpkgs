{ stdenv, fetchurl, SDL, alsaLib, cmake, fftwSinglePrec, fluidsynth
, fltk13, jack2, libvorbis , libsamplerate, libsndfile, pkgconfig
, pulseaudio, qt4, freetype
}:

stdenv.mkDerivation  rec {
  name = "lmms-${version}";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/LMMS/lmms/archive/v${version}.tar.gz";
    sha256 = "0p0lfy3vmxjf9nwajzyhl2jscpmbi26qqqsy1hsa4ljc0plfz60p";
  };

  buildInputs = [
    SDL alsaLib cmake fftwSinglePrec fltk13 fluidsynth jack2
    libsamplerate libsndfile libvorbis pkgconfig pulseaudio qt4
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Linux MultiMedia Studio";
    homepage = "http://lmms.sourceforge.net";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
