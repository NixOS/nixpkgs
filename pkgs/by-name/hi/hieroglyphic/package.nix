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
  appstream,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hieroglyphic";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = "Hieroglyphic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-021qmXZDgeGLpsrhlqMlXiVONltuKFCra0/mTT/Bul0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PMHDHRkCMlcv3LrCYH3eU3YgmWR4KFNsIRqiXq9oIcA=";
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/FineFindus/Hieroglyphic/releases/tag/v${finalAttrs.version}";
    description = "Tool based on detexify for finding LaTeX symbols from drawings";
    homepage = "https://apps.gnome.org/en/Hieroglyphic/";
    license = lib.licenses.gpl3Only;
    mainProgram = "hieroglyphic";
    maintainers = with lib.maintainers; [ tomasajt ];
    teams = [ lib.teams.gnome-circle ];
    # Note: upstream currently has case-insensititvity issues on darwin
    platforms = lib.platforms.linux;
  };
})
