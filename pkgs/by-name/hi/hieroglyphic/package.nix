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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = "Hieroglyphic";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-8UUFatJwtxqumhHd0aiPk6nKsaaF/jIIqMFxXye0X8U=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-JHlvSo5wl0G9yF9KIwFXILu7T0Pv6f6JC0Q90wfuD94=";
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
