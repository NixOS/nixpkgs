{ mkDerivation, lib, fetchurl, pkgconfig, qtbase, qttools, alsaLib, libjack2 }:

mkDerivation rec {
  version = "0.6.1";
  pname = "qmidinet";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/${pname}-${version}.tar.gz";
    sha256 = "1nvbvx3wg2s6s7r4x6m2pm9nx7pdz00ghw9h10wfqi2s474mwip0";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [  qtbase qttools alsaLib libjack2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with lib; {
    description = "A MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network";
    homepage = http://qmidinet.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
