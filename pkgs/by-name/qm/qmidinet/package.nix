{
  stdenv,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  alsa-lib,
  libjack2,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.0.2";
  pname = "qmidinet";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/qmidinet-${finalAttrs.version}.tar.gz";
    hash = "sha256-gBAaK32rabujVsCIOJcNZluaKpFz1KjICcRbKgvmXaQ=";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    alsa-lib
    libjack2
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
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
