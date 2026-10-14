{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  jansson,
  luajit,
  meson,
  ninja,
  openssl,
  pkg-config,
  unstableGitUpdater,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "libresplit";
  version = "0-unstable-2026-08-14";

  src = fetchFromGitHub {
    owner = "LibreSplit";
    repo = "LibreSplit";
    rev = "2c7f6610519cb98c3a1529ab2383ae0cd50d5dea";
    hash = "sha256-fU0ghAMXOeygKWZYPtwriw2qxGh+5pnF392+rxrIGqg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    jansson
    luajit
    openssl
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/LibreSplitDev/LibreSplit";
    description = "Speedrun timer with auto splitting and load removal for Linux";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "libresplit";
    platforms = lib.platforms.linux;
  };
}
