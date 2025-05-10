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
  fetchurl,
  cargo,
  desktop-file-utils,

  gtk4,
  libadwaita,
  glib,
  poppler,
  gtksourceview5,

  nix-update-script,
}:

let
  poppler' = poppler.overrideAttrs (oldAttrs: rec {
    version = "25.01.0";

    src = fetchurl {
      url = "https://poppler.freedesktop.org/poppler-${version}.tar.xz";
      hash = "sha256-fu/BIiB7u9cqMDxeB0P0lB6K6GHiTc8FAeGM4dFBQRI=";
    };

    patches = [ ];

    doCheck = false;
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clapgrep";
  version = "25.04";

  src = fetchFromGitHub {
    owner = "luleyleo";
    repo = "clapgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mx52z+YpHdq4zSmH1d3KlNhj3ezpoWMGB0FEr4B20sg=";
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
    poppler'
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
