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

stdenv.mkDerivation rec {
  pname = "mictray";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "Junker";
    repo = "mictray";
    rev = "1f879aeda03fbe87ae5a761f46c042e09912e1c0";
    sha256 = "0achj6r545c1sigls79c8qdzryz3sgldcyzd3pwak1ymim9i9c74";
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

  meta = with lib; {
    homepage = "https://github.com/Junker/mictray";
    description = "System tray application for microphone";
    longDescription = ''
      MicTray is a Lightweight system tray application which lets you control the microphone state and volume.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.anpryl ];
    mainProgram = "mictray";
  };
}
