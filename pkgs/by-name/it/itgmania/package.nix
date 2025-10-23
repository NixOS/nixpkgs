{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nasm,
  pkg-config,
  copyDesktopItems,
  alsa-lib,
  glew,
  glib,
  gtk3,
  libmad,
  libogg,
  libpulseaudio,
  libusb-compat-0_1,
  libvorbis,
  libXtst,
  udev,
  makeWrapper,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "itgmania";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "itgmania";
    repo = "itgmania";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-C9qVUZdRnKbQgfgbXnzT+lI2+FEXBaMQv/U6UF5wyzo=";
  };

  nativeBuildInputs = [
    cmake
    nasm
    pkg-config
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    glew
    glib
    gtk3
    libmad
    libogg
    libpulseaudio
    libusb-compat-0_1
    libvorbis
    libXtst
    udev
  ];

  cmakeFlags = lib.optionals (!stdenv.hostPlatform.isx86) [ "-DWITH_MINIMAID=off" ];

  postInstall = ''
    makeWrapper $out/itgmania/itgmania $out/bin/itgmania \
      --chdir $out/itgmania

    mkdir -p $out/share/icons/hicolor/scalable/apps/
    ln -s $out/itgmania/Data/logo.svg $out/share/icons/hicolor/scalable/apps/itgmania.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "itgmania";
      desktopName = "ITGmania";
      genericName = "Rhythm and dance game";
      tryExec = "itgmania";
      exec = "itgmania";
      terminal = false;
      icon = "itgmania";
      type = "Application";
      comment = "A cross-platform rhythm video game.";
      categories = [
        "Game"
        "ArcadeGame"
      ];
    })
  ];

  meta = {
    homepage = "https://www.itgmania.com/";
    description = "Fork of StepMania 5.1, improved for the post-ITG community";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ftsimas
      maxwell-lt
    ];
    mainProgram = "itgmania";
  };
})
