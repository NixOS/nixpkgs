{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  wrapGAppsHook4,
  pkg-config,
  blueprint-compiler,
  meson,
  ninja,
  rustc,
  cargo,
  desktop-file-utils,

  gtk4,
  libadwaita,
  glib,
  poppler,
  gtksourceview5,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clapgrep";
  version = "25.10";

  src = fetchFromGitHub {
    owner = "luleyleo";
    repo = "clapgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y7XwS4jOj8WHi3ntLwPne86/ZVkdBaWrDtPmUcUG4XE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-iNGYFyAF3Qo6x2VaBsyrLTSYPn6OZ6TWfXDTXqbovhE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook4
    pkg-config
    blueprint-compiler
    rustc
    rustPlatform.cargoSetupHook
    cargo
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    poppler
    gtksourceview5
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Search through all your files";
    homepage = "https://github.com/luleyleo/clapgrep";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "clapgrep";
  };
})
