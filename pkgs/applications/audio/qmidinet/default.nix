{ stdenv, fetchurl, pkgconfig, qt5, alsaLib, libjack2 }:

stdenv.mkDerivation rec {
  version = "0.5.2";
  name = "qmidinet-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/${name}.tar.gz";
    sha256 = "0y2w3rymvc35r291sp2qaxn36wjwvxzk2iaw9y30q9fqc0vlpdns";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [  qt5.qtbase qt5.qttools alsaLib libjack2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "A MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network";
    homepage = http://qmidinet.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
