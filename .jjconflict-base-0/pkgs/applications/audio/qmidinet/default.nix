{
  mkDerivation,
  lib,
  fetchurl,
  pkg-config,
  qtbase,
  qttools,
  alsa-lib,
  libjack2,
}:

mkDerivation rec {
  version = "0.9.4";
  pname = "qmidinet";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/${pname}-${version}.tar.gz";
    sha256 = "sha256-7Ui4kUgYgpPVAaaINrd6WGZoYon5UuHszGVaHafb/p0=";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [
    qtbase
    qttools
    alsa-lib
    libjack2
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network";
    mainProgram = "qmidinet";
    homepage = "http://qmidinet.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
