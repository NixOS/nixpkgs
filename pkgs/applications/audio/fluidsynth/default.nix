{ stdenv, fetchurl, alsaLib, glib, jackaudio, libsndfile, pkgconfig
, pulseaudio }:

stdenv.mkDerivation  rec {
  name = "fluidsynth-${version}";
  version = "1.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/fluidsynth/${name}.tar.bz2";
    sha256 = "1x73a5rsyvfmh1j0484kzgnk251q61g1g2jdja673l8fizi0xd24";
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
