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
  wayland-scanner,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sway-audio-idle-inhibit";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6bdIkNosp/mzH5SiyK6Mox/z8kuFk5RLMmcFZ2VIi0g=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
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
})
