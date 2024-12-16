{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  glib,
  gtk4,
  libadwaita,
  gettext,
  appstream,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hieroglyphic";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = "Hieroglyphic";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-bRxG+NHwHPJ2J/zTFks6M/Uy7XQ0cm8FBzlBC4yORm4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-8vo6pV04M8+FYzFpG4zcJAkOu2BcHzkPsiu9/2IQCmM=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    appstream
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  # needed for darwin
  env.GETTEXT_DIR = "${gettext}";

  meta = {
    changelog = "https://github.com/FineFindus/Hieroglyphic/releases/tag/v${finalAttrs.version}";
    description = "Tool based on detexify for finding LaTeX symbols from drawings";
    homepage = "https://apps.gnome.org/en/Hieroglyphic/";
    license = lib.licenses.gpl3Only;
    mainProgram = "hieroglyphic";
    maintainers = with lib.maintainers; [ tomasajt ] ++ lib.teams.gnome-circle.members;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
