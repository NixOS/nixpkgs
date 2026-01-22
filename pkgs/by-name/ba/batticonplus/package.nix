{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gettext,
  glib,
  gtk3,
  libnotify,
  wrapGAppsHook3,
  libayatana-appindicator,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "batticonplus";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "artist4xlibre";
    repo = "batticonplus";
    tag = "v${version}";
    hash = "sha256-H9ZoiQ5zWMIoWWol2a6f9Z8g4o9DIHYdF+/nEsBfuzc=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libnotify
    libayatana-appindicator
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "WITH_APPINDICATOR=1"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight battery status icon for the system tray and notifier (based on cbatticon)";
    mainProgram = "batticonplus";
    homepage = "https://github.com/artist4xlibre/batticonplus";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yechielw ];
  };
}
