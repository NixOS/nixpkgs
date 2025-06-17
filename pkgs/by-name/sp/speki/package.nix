{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libiconv,
  glib,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  xdotool,
  wrapGAppsHook3,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "speki";
  version = "0.1.0-unstable-2025-06-17";

  src = fetchFromGitHub {
    owner = "tbs1996";
    repo = "spekispace";
    rev = "cc11bce95f63eda31f4e5fdf9df9736a36fe17b5";
    hash = "sha256-bv3WOw1FyfBTombSqyAVEWnP092s8OQzkKr5TwnyplE=";
  };

  cargoHash = "sha256-ZHjompyL8xx9r5DWqIsyRa0Zq33f4Xngz8kNF0mdIzY=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    libiconv
    glib
    gtk3
    libsoup_3
    webkitgtk_4_1
    xdotool
  ];

  meta = {
    description = "Ontological flashcard app";
    homepage = "https://github.com/tbs1996/spekispace";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tbs1996 ];
    mainProgram = "speki";
  };
})
