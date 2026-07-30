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
  pipewire,
  alsa-lib,
  makeWrapper,
  docutils,
  wayland-scanner,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfwbar";
  version = "1.0_beta17";

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = "sfwbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xenXcGo5kdntOsSOlXaYA9WZ9Ed0hncGlb5Jgv6rbio=";
  };

  buildInputs = [
    gtk3
    json_c
    gtk-layer-shell
    libpulseaudio
    libmpdclient
    libxkbcommon
    pipewire
    alsa-lib
    docutils # for rst2man
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    wayland-scanner
    wrapGAppsHook3
  ];

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
