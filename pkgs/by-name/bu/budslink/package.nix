{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gjs,
  glib,
  gtk4,
  libadwaita,
  librsvg,
  pango,
  cairo,
  gobject-introspection,
  libpulseaudio,
  wrapGAppsHook4,
  desktop-file-utils,
  appstream,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budslink";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "maniacx";
    repo = "BudsLink";
    rev = "v${finalAttrs.version}";
    hash = "sha256-s87pFrSY8esCYsqZ4M3mPRxoo29qrgFbEYBdk9E/P/A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gjs
    glib
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    appstream
    appstream-glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
    pango
    cairo
    gjs
    gobject-introspection
    libpulseaudio
  ];

  postPatch = ''
    substituteInPlace src/app.js \
      --replace-fail "import GLibUnix from 'gi://GLibUnix';" "" \
      --replace-fail "GLibUnix.signal_add(" "GLib.unix_signal_add("
  '';

  meta = {
    description = "Battery tracking and ANC control for various Bluetooth earbuds (AirPods, Beats, Sony, Galaxy Buds, Nothing/CMF)";
    homepage = "https://github.com/maniacx/BudsLink";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "budslink";
  };
})
