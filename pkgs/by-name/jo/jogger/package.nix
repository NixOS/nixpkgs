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
  version = "1.2.4-unstable-2024-04-05";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "baarkerlounger";
    repo = "jogger";
    rev = "09386b9503a9b996b86ea4638268403868b24d6a";
    hash = "sha256-oGjqYRHkYk22/RzDc5c0066SlOPGRGC6z/BTn1DM03o=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+8mMJgLHLUdFLOwjhXolHcVUP+s/j6PlWeRh8sGRYTc=";
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
