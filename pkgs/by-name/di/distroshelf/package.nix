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
  libxml2,
  vte-gtk4,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "distroshelf";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "ranfdev";
    repo = "DistroShelf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6UAsG8K/j6lX6mwZOg5JZYbYUe98i6+nPaPLjQMM3w8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-0ZOgiLGvcjpBcYdEVrcerdIJBPMhS8sPtUOY4t+eUjg=";
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
    libxml2
  ];

  buildInputs = [
    glib
    libadwaita
    vte-gtk4
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
