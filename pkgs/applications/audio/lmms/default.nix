{ stdenv, fetchurl, SDL, alsaLib, cmake, fftwSinglePrec, fluidsynth
, fltk13, libjack2, libvorbis , libsamplerate, libsndfile, pkgconfig
, libpulseaudio, qt4, freetype
}:

stdenv.mkDerivation  rec {
  name = "lmms-${version}";
  version = "1.1.3";

  src = fetchurl {
    url = "https://github.com/LMMS/lmms/archive/v${version}.tar.gz";
    sha256 = "1g76z7ha3hd53vbqaq9n1qg6s3lw8zzaw51iny6y2bz0j1xqwcsr";
  };

  buildInputs = [
    SDL alsaLib cmake fftwSinglePrec fltk13 fluidsynth libjack2
    libsamplerate libsndfile libvorbis pkgconfig libpulseaudio qt4
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
