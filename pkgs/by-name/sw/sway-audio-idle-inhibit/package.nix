{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libpulseaudio,
  wayland,
  wayland-protocols,
}:
stdenv.mkDerivation {
  pname = "sway-audio-idle-inhibit";
  version = "unstable-2023-08-09";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = "c850bc4812216d03e05083c69aa05326a7fab9c7";
    sha256 = "sha256-MKzyF5xY0uJ/UWewr8VFrK0y7ekvcWpMv/u9CHG14gs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libpulseaudio
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "Prevents swayidle from sleeping while any application is outputting or receiving audio";
    homepage = "https://github.com/ErikReider/SwayAudioIdleInhibit";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rafaelrc ];
    mainProgram = "sway-audio-idle-inhibit";
  };
}
