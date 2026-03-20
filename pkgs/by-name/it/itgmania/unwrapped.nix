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
  libxtst,
  udev,
  makeDesktopItem,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "itgmania";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "itgmania";
    repo = "itgmania";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-RkV/OIDudt2XemhaFRY7IA5o7Q2w+j01tauD7KpzYpA=";
  };

  nativeBuildInputs = [
    cmake
    nasm
    pkg-config
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
    libxtst
    udev
  ];

  cmakeFlags = lib.optionals (!stdenv.hostPlatform.isx86) [ "-DWITH_MINIMAID=off" ];

  postInstall = ''
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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.itgmania.com/";
    description = "Fork of StepMania 5.1, improved for the post-ITG community";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ftsimas
      maxwell-lt
      ungeskriptet
    ];
    mainProgram = "itgmania";
  };
})
