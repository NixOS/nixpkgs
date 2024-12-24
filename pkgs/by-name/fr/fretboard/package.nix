{
  lib,
  blueprint-compiler,
  cargo,
  darwin,
  desktop-file-utils,
  fetchFromGitHub,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fretboard";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "bragefuglseth";
    repo = "fretboard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8xINlVhWgg73DrRi8S5rhNc1sbG4DbWOsiEBjU8NSXo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-LSL7VvRgA8MaFXn/vi5Zf1sY4cqv0a9PNnZ3JlDNIaE=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs =
    [
      glib
      gtk4
      libadwaita
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Foundation
    ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=incompatible-function-pointer-types"
    ]
  );

  meta = {
    changelog = "https://github.com/bragefuglseth/fretboard/releases/tag/v${finalAttrs.version}";
    description = "Look up guitar chords";
    homepage = "https://apps.gnome.org/Fretboard/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "fretboard";
    maintainers = lib.teams.gnome-circle.members;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
