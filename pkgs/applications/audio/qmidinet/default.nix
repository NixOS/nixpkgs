{ stdenv, fetchurl, qt5, alsaLib, libjack2 }:

stdenv.mkDerivation rec {
  version = "0.4.1";
  name = "qmidinet-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/${name}.tar.gz";
    sha256 = "1hh06g19lfh6r673avfvy0l2mq999mxk2jnv396226swj97lv7yz";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [  qt5.qtbase qt5.qttools alsaLib libjack2 ];

  meta = with stdenv.lib; {
    description = "A MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network";
    homepage = http://qmidinet.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
