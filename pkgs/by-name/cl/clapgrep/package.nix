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
  version = "25.05+1";

  src = fetchFromGitHub {
    owner = "luleyleo";
    repo = "clapgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DL3voYSsNGjPb1CnPuJGg+7UgWYZO7cH5T2Z37BuDSE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-hTejIaXIAi8opZdE2X3vEi+VYoSti8RNB41ikVOWGPk=";
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
