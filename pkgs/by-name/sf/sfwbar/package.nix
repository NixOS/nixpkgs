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
let
  version = "1.0_beta16";
in
stdenv.mkDerivation {
  pname = "sfwbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = "sfwbar";
    rev = "v${version}";
    hash = "sha256-jMEbw3Xla2cod/oKFQ4bD3sTHi7DZ0deG0H0Yt0Y7ck=";
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
    changelog = "https://github.com/LBCrion/sfwbar/releases/tag/v${version}";
    mainProgram = "sfwbar";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      NotAShelf
    ];
    license = lib.licenses.gpl3Only;
  };
}
