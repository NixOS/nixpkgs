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
<<<<<<< HEAD
  version = "25.10";
=======
  version = "25.07";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "luleyleo";
    repo = "clapgrep";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Y7XwS4jOj8WHi3ntLwPne86/ZVkdBaWrDtPmUcUG4XE=";
=======
    hash = "sha256-XH0ei0x4QeCaVLDpRrHFgI6ExR5CSX7Pzg1PCrTyBec=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
<<<<<<< HEAD
    hash = "sha256-iNGYFyAF3Qo6x2VaBsyrLTSYPn6OZ6TWfXDTXqbovhE=";
=======
    hash = "sha256-tKC3YgLECV3EMMzBLBPj0GntHk2oavXGpTwWG9EjH1U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
