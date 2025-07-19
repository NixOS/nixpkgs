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
  version = "1.3.1-unstable-2023-05-30";

  src = fetchFromGitHub {
    owner = "wahjam";
    repo = "wahjam";
    rev = "4fde74da3be1fa53cdc2d3bc4b577b40951d6809";
    hash = "sha256-WYfLQxToyjAE+R2eaBKpDJGfkvrOTza8a6JbN9AL3aE=";
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

  meta = {
    description = "Software for musicians to play together over the internet";
    mainProgram = "wahjam";
    homepage = "https://github.com/wahjam/wahjam";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ caseyavila ];
  };
}
