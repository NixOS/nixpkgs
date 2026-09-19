{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  gettext,
  glib,
  gtk4,
  libadwaita,
  gjs,
  bluez,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budslink";
  version = "0.2.1";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maniacx";
    repo = "BudsLink";
    rev = "7405f6343f8390b5a78e358d3ad4c0870b2270bd";
    hash = "sha256-ifXtA90qmO9cAo02j4pDGEP5NbUvonBwmX1Yv3MnF/E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    gettext
    gjs
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gjs
    bluez
    libpulseaudio
  ];

  meta = {
    description = "Feature control and battery monitoring for Bluetooth earbuds";
    homepage = "https://github.com/maniacx/BudsLink";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "budslink";
  };
})
