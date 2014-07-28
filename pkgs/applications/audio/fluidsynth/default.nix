{ stdenv, fetchurl, alsaLib, glib, jackaudio, libsndfile, pkgconfig
, pulseaudio }:

stdenv.mkDerivation  rec {
  name = "fluidsynth-${version}";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/fluidsynth/${name}.tar.bz2";
    sha256 = "00gn93bx4cz9bfwf3a8xyj2by7w23nca4zxf09ll53kzpzglg2yj";
  };

  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i '40 i\
    #include <CoreAudio/AudioHardware.h>\
    #include <CoreAudio/AudioHardwareDeprecated.h>' \
    src/drivers/fluid_coreaudio.c
  '';

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin
    "-framework CoreAudio";

  buildInputs = [ glib libsndfile pkgconfig ]
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ alsaLib pulseaudio jackaudio ];

  meta = with stdenv.lib; {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage    = http://www.fluidsynth.org;
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ goibhniu lovek323 ];
    platforms   = platforms.unix;
  };
}
