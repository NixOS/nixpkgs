{
  lib,
  cargo,
  copyDesktopItems,
  fetchFromGitHub,
  glib,
  gtk4,
  libadwaita,
  makeDesktopItem,
  mpv,
  openssl,
  pkg-config,
  rustc,
  rustPlatform,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dewduct";
  version = "v0.2.3";

  src = fetchFromGitHub {
    owner = "DaKnig";
    repo = "DewDuct";
    rev = finalAttrs.version;
    hash = "sha256-XNHq5tuogJkdTGq37/mCZVXzrmjE1tKLa3rGOpg6T3Y=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    name = "dewduct-${finalAttrs.version}";
    hash = "sha256-w760JgvCgVXjoZEg44oMP8gjybb858ERJhPYHFUU9H4=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    mpv
    openssl
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${mpv}/bin"
    )
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 target/release/dewduct $out/bin/dewduct

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "dewduct";
      exec = "dewduct";
      type = "Application";
      desktopName = "DewDuct";
      comment = finalAttrs.meta.description;
      categories = [
        "AudioVideo"
        "GNOME"
        "GTK"
        "Player"
        "Video"
      ];
      keywords = [
        "YouTube"
      ];
    })
  ];

  meta = with lib; {
    changelog = "https://github.com/DaKnig/DewDuct/releases/tag/${finalAttrs.version}";
    description = "YouTube client for desktop and mobile Linux";
    homepage = "https://github.com/DaKnig/DewDuct";
    license = licenses.gpl3Plus;
    mainProgram = "dewduct";
    maintainers = with maintainers; [ michaelgrahamevans ];
    platforms = platforms.linux;
  };
})
