{ stdenv, fetchurl, alsaLib, glib, jackaudio, libsndfile, pkgconfig
, pulseaudio }:

stdenv.mkDerivation  rec {
  name = "fluidsynth-${version}";
  version = "1.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/fluidsynth/${name}.tar.bz2";
    sha256 = "1x73a5rsyvfmh1j0484kzgnk251q61g1g2jdja673l8fizi0xd24";
  };

  buildInputs = [ alsaLib glib jackaudio libsndfile pkgconfig pulseaudio ];

  meta = with stdenv.lib; {
    description = "real-time software synthesizer based on the SoundFont 2 specifications";
    homepage = http://www.fluidsynth.org;
    license = licenses.lgpl2;
    maintainers = [ maintainers.goibhniu ];
  };
}
