{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pandoc,
  pkg-config,
  qttools,
  alsa-lib,
  drumstick,
  qtbase,
  qtsvg,
}:

stdenv.mkDerivation rec {
  pname = "kmetronome";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-FJVmSMu0KDoq8DHRxxGyHQQflPCvH1h+WdsV9wcPAPA=";
  };

  nativeBuildInputs = [
    cmake
    pandoc
    pkg-config
    qttools
  ];

  buildInputs = [
    alsa-lib
    drumstick
    qtbase
    qtsvg
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://kmetronome.sourceforge.io/";
    description = "ALSA MIDI metronome with Qt interface";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
    mainProgram = "kmetronome";
  };
}
