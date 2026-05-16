{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  pkg-config,
  meson,
  ninja,
  blueprint-compiler,
  glib,
  gtk4,
  libadwaita,
  rustc,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eyedropper";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = "eyedropper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t/OFA4oDXtnMmyFptG7zsGW5ubaSNrSnaDR1l9nVbLQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-39BWpyGhX6fYzxwrodiK1A3ASuRiI7tOA+pSKu8Bx5Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    cargo
    rustc
    rustPlatform.cargoSetupHook
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
    description = "Pick and format colors";
    homepage = "https://github.com/FineFindus/eyedropper";
    changelog = "https://github.com/FineFindus/eyedropper/releases/tag/v${finalAttrs.version}";
    mainProgram = "eyedropper";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    teams = [ lib.teams.gnome-circle ];
  };
})
