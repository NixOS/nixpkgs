{ mkDerivation, lib, fetchurl, pkg-config, qtbase, qttools, alsa-lib, libjack2 }:

mkDerivation rec {
  version = "0.9.1";
  pname = "qmidinet";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/${pname}-${version}.tar.gz";
    sha256 = "sha256-cDgF5hbjy5DzGn4Rlmb76XzRa2wURVwPu2rQRKENxQU=";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [  qtbase qttools alsa-lib libjack2 ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "A MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network";
    homepage = "http://qmidinet.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
