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
  version = "26.09";

  src = fetchFromGitHub {
    owner = "luleyleo";
    repo = "clapgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6drZhyWwwunKWBMCtpihq+ak5SWkxKILf/BEHEHVWBc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-lkQ78BR1wj+R0rFMQ8q5B12ZOHNEbniYieFZ+1M9au0=";
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
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "clapgrep";
  };
})
