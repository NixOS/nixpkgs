{ stdenv, fetchurl, qt4, alsaLib, libjack2 }:

stdenv.mkDerivation rec {
  version = "0.2.1";
  name = "qmidinet-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/${name}.tar.gz";
    sha256 = "1a1pj4w74wj1gcfv4a0vzcglmr5sw0xp0y56w8rk3ig4k11xi8sa";
  };

  buildInputs = [ qt4 alsaLib libjack2 ];

  meta = with stdenv.lib; {
    description = "A MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network";
    homepage = http://qmidinet.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
