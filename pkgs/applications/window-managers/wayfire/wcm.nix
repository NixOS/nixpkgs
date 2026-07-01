{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  wayfire,
  wf-shell,
  wayland-scanner,
  wayland-protocols,
  gtk3,
  gtkmm3,
  libevdev,
  libxml2,
  libxkbcommon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wcm";
  version = "0.11.0-unstable-2025-11-23";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wcm";
    rev = "d7e3d6783f3e7d10c3c4edf556be7a5342626065";
    fetchSubmodules = true;
    hash = "sha256-O4BYwb+GOMZIn3I2B/WMJ5tUZlaegvwBuyNK9l/gxvQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    wayfire
    wf-shell
    wayland-protocols
    gtk3
    gtkmm3
    libevdev
    libxml2
    libxkbcommon
  ];

  meta = {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      teatwig
      wucke13
      wineee
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wcm";
  };
})
