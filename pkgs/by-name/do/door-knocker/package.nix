{
  stdenv,
  lib,
  fetchFromCodeberg,
  blueprint-compiler,
  desktop-file-utils,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "door-knocker";
  version = "0.8.0";

  src = fetchFromCodeberg {
    owner = "tytan652";
    repo = "door-knocker";
    rev = finalAttrs.version;
    hash = "sha256-Yz/HVffOJNpu0D8SE32ehwI3UQ7yPKMqR6yYIAVuBDc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = {
    description = "Tool to check the availability of portals";
    homepage = "https://codeberg.org/tytan652/door-knocker";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ symphorien ];
    platforms = lib.platforms.linux;
    mainProgram = "door-knocker";
  };
})
