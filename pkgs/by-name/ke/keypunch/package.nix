{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  cargo,
  rustc,
  meson,
  ninja,
  pkg-config,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  wrapGAppsHook4,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keypunch";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "bragefuglseth";
    repo = "keypunch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C0WD8vBPlKvCJHVJHSfEbMIxNARoRrCn7PNebJ0rkoI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-SQ1BI9BuUfUvafsBnC1P5YQ8qVAaer6ywuRQkfS/V1w=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc

    meson
    ninja

    pkg-config
    appstream
    blueprint-compiler
    desktop-file-utils
    gettext

    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Practice your typing skills";
    homepage = "https://github.com/bragefuglseth/keypunch";
    license = lib.licenses.gpl3Plus;
    mainProgram = "keypunch";
    maintainers = with lib.maintainers; [
      tomasajt
      getchoo
    ];
    platforms = lib.platforms.linux;
  };
})
