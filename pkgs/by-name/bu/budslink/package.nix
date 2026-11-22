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
    tag = "v${finalAttrs.version}";
    hash = "sha256-bOVymVN9WoGUKvYUZ93OcIu3Avw1ybmAK3W4uViXzQc=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "get_option('libdir'),  APP_ID)" "get_option('libdir'))"
  '';

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
    libadwaita
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
