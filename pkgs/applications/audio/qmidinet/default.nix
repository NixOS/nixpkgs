{ mkDerivation, lib, fetchurl, pkgconfig, qtbase, qttools, alsaLib, libjack2 }:

mkDerivation rec {
  version = "0.6.2";
  pname = "qmidinet";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/${pname}-${version}.tar.gz";
    sha256 = "0siqzyhwg3l9av7jbca3bqdww7xspjlpi9ya4mkj211xc3a3a1d6";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [  qtbase qttools alsaLib libjack2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with lib; {
    description = "A MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network";
    homepage = "http://qmidinet.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
