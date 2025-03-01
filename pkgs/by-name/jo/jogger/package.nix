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
  version = "1.2.5";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "baarkerlounger";
    repo = "jogger";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-bju9XXMT6HRHG9QViO+FQCYQ+llrC+GP/AlIha0mxkM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-k4nUtFdwCWa8flSkOEQe7UqorpYPCGrcXHTvVOqoAQI=";
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
