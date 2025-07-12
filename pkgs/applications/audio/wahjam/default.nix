{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qmake,
  wrapQtAppsHook,
  qtbase,
  qtkeychain,
  libogg,
  libvorbis,
  libresample,
  portaudio,
  portmidi,
}:

stdenv.mkDerivation {
  pname = "wahjam";
  version = "20230530";

  src = fetchFromGitHub {
    owner = "wahjam";
    repo = "wahjam";
    rev = "4fde74d";
    sha256 = "sha256-WYfLQxToyjAE+R2eaBKpDJGfkvrOTza8a6JbN9AL3aE=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtkeychain
    libogg
    libvorbis
    libresample
    portaudio
    portmidi
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp qtclient/wahjam $out/bin/wahjam
  '';

  meta = with lib; {
    description = "Software for musicians to play together over the internet";
    mainProgram = "wahjam";
    homepage = "http://wahjam.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ caseyavila ];
  };
}
