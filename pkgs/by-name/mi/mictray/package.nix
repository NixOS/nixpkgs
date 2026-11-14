{
  fetchFromGitHub,
  gtk3,
  lib,
  libgee,
  libnotify,
  meson,
  ninja,
  pkg-config,
  pulseaudio,
  stdenv,
  vala,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "mictray";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "Junker";
    repo = "mictray";
    rev = "1f879aeda03fbe87ae5a761f46c042e09912e1c0";
    hash = "sha256-5LAUU43Vh6n4He171ujT4/v8G0YsHU1f1IEVUrKRkCk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libgee
    libnotify
    pulseaudio
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/Junker/mictray";
    description = "System tray application for microphone";
    longDescription = ''
      MicTray is a Lightweight system tray application which lets you control the microphone state and volume.
    '';
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.anpryl ];
    mainProgram = "mictray";
  };
}
