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
  version = "4.0";

  src = fetchFromGitHub {
    owner = "bragefuglseth";
    repo = "keypunch";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Xd4fzreComOUnoJ6l2ncMWn6DlUeRCM+YwApilhFd/8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    hash = "sha256-agFOxSZBi8f0zEPd+ha5c3IAbSH2jHfUx2iNeHFs9jI=";
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
