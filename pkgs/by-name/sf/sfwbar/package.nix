{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  meson,
  ninja,
  json_c,
  pkg-config,
  gtk-layer-shell,
  libpulseaudio,
  libmpdclient,
  libxkbcommon,
  alsa-lib,
  makeWrapper,
  docutils,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfwbar";
  version = "1.0_beta16.1";

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = "sfwbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WA9BXX+0VR8eSdHOYLs+DoazBqVwMllQSxkubq4SkWo=";
  };

  buildInputs = [
    gtk3
    json_c
    gtk-layer-shell
    libpulseaudio
    libmpdclient
    libxkbcommon
    alsa-lib
    docutils # for rst2man
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    wayland-scanner
  ];

  postFixup = ''
    wrapProgram $out/bin/sfwbar \
      --suffix XDG_DATA_DIRS : $out/share
  '';

  meta = {
    homepage = "https://github.com/LBCrion/sfwbar";
    description = "Flexible taskbar application for wayland compositors, designed with a stacking layout in mind";
    changelog = "https://github.com/LBCrion/sfwbar/releases/tag/v${finalAttrs.version}";
    mainProgram = "sfwbar";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      NotAShelf
    ];
    license = lib.licenses.gpl3Only;
  };
})
