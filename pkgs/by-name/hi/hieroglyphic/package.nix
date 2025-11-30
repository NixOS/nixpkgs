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
  openssl,
  appstream,
  onnxruntime,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hieroglyphic";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = "Hieroglyphic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mqoYdHpVnivDTblvoaACyCE7Y25cfLj1m0Q5D33zEfk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-kArrsHW+cFZQQgIEL+7Os8ixKtuIZAByEr6D4XDmfRE=";
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
    openssl
  ];

  env = {
    ORT_STRATEGY = "system";
    ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";
  };

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
    # https://github.com/FineFindus/Hieroglyphic/issues/40
    platforms = lib.platforms.linux;
  };
})
