{ stdenv, fetchFromGitHub, SDL, alsaLib, cmake, fftwSinglePrec, fluidsynth
, fltk13, libjack2, libvorbis , libsamplerate, libsndfile, pkgconfig
, libpulseaudio, qt4, freetype, libgig
}:

stdenv.mkDerivation rec {
  name = "lmms-${version}";
  version = "1.1.90";

  src = fetchFromGitHub {
    owner = "LMMS";
    repo = "lmms";
    rev = "v${version}";
    sha256 = "0njiarndwqamqiinr1wbwkzjn87yzr1z5k9cfwk0jdkbalgakkq3";
  };

  buildInputs = [
    SDL alsaLib cmake fftwSinglePrec fltk13 fluidsynth libjack2 libgig
    libsamplerate libsndfile libvorbis pkgconfig libpulseaudio qt4
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Linux MultiMedia Studio";
    homepage = http://lmms.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
