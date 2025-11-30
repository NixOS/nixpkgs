{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wrapGAppsHook4,
  desktop-file-utils,
  rustPlatform,
  cargo,
  rustc,
  pkg-config,
  glib,
  libadwaita,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "distroshelf";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "ranfdev";
    repo = "DistroShelf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4rNdp0g/QaiLnKGC4baYAq29dxluyZ+9TgeBlqidRp0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-5luI46rSgB+N0OKQzSopEhCCEnwAhMabRit9MtsSSVA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
    desktop-file-utils
    pkg-config
  ];

  buildInputs = [
    glib
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/ranfdev/DistroShelf";
    description = "GUI for Distrobox Containers";
    mainProgram = "distroshelf";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
