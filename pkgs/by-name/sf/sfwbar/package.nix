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
}:
let
  version = "1.0_beta14";
in
stdenv.mkDerivation {
  pname = "sfwbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = "sfwbar";
    rev = "v${version}";
    hash = "sha256-4brP1SXaWq/L0D87rvlrWhLU1oFPSwNNxBSzRr4jsTM=";
  };

  buildInputs = [
    gtk3
    json_c
    gtk-layer-shell
    libpulseaudio
    libmpdclient
    libxkbcommon
    alsa-lib
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
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
