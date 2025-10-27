{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  alsa-lib,
  libjack2,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.9.4";
  pname = "qmidinet";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/qmidinet-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-7Ui4kUgYgpPVAaaINrd6WGZoYon5UuHszGVaHafb/p0=";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    alsa-lib
    libjack2
  ];

  nativeBuildInputs = [
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  meta = {
    description = "MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network";
    mainProgram = "qmidinet";
    homepage = "http://qmidinet.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
