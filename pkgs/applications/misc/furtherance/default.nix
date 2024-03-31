{ lib, stdenv, fetchFromGitHub, rustPlatform
, appstream-glib, cargo, desktop-file-utils, glib, libadwaita, meson, ninja
, pkg-config, rustc, wrapGAppsHook4
, dbus, gtk4, sqlite
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "furtherance";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "lakoliu";
    repo = "Furtherance";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TxYARpCqqjjwinoRU2Wjihp+FYIvcI0YCGlOuumX6To=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-VGBxBHs/kqW0mvOiz0UQRg0duDmW8ee9cSh6EOT9aaY=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    glib
    gtk4
    libadwaita
    sqlite
  ];

  meta = with lib; {
    description = "Track your time without being tracked";
    mainProgram = "furtherance";
    homepage = "https://github.com/lakoliu/Furtherance";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ CaptainJawZ ];
  };
})
