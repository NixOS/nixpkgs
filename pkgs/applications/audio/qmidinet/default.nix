{ mkDerivation, lib, fetchurl, pkgconfig, qtbase, qttools, alsaLib, libjack2 }:

mkDerivation rec {
  version = "0.6.3";
  pname = "qmidinet";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/${pname}-${version}.tar.gz";
    sha256 = "04jbvnf6yp9l0bhl1ym6zqkmaz8c2az3flq7qgflaxzj3isns1p1";
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
