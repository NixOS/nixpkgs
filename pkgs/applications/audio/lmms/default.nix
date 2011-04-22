{ stdenv, fetchurl, SDL, alsaLib, cmake, fftw, jackaudio, libogg,
libsamplerate, libsndfile, pkgconfig, pulseaudio, qt4 }:

stdenv.mkDerivation  rec {
  name = "lmms-${version}";
  version = "0.4.10";

  src = fetchurl {
    url = "mirror://sourceforge/lmms/${name}.tar.bz2";
    sha256 = "035cqmxcbr9ipnicdv5l7h05q2hqbavxkbaxyq06ppnv2y7fxwrb";
  };

  buildInputs = [ SDL alsaLib cmake fftw jackaudio libogg
    libsamplerate libsndfile pkgconfig pulseaudio qt4 ];

  meta = with stdenv.lib; {
    description = "Linux MultiMedia Studio";
    homepage = "http://lmms.sourceforge.net";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
