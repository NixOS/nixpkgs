{
  lib,
  stdenv,
  fetchFromGitea,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  libshumate,
  alsa-lib,
  espeak,
  sqlite,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jogger";
  version = "1.3.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "baarkerlounger";
    repo = "jogger";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-EPk5uuloubCp/S81yYFCbt8E7XJOezk16pIvFI+QfUk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-hoZrc8d4/5HsyKkDfU0EQcQsj7Y6BDOM/KhFG5e2nAs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    libshumate
    alsa-lib
    espeak
    sqlite
    glib-networking
  ];

  meta = {
    description = "App for Gnome Mobile to Track running and other workouts";
    homepage = "https://codeberg.org/baarkerlounger/jogger";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "jogger";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
