{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  openssl,
  darwin,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "share-preview";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "share-preview";
    rev = finalAttrs.version;
    hash = "sha256-FqualaTkirB+gBcgkThQpSBHhM4iaXkiGujwBUnUX0E=";
  };

  patches = [
    ./wasm-bindgen.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src patches;
    name = "share-preview-${finalAttrs.version}";
    hash = "sha256-lDSRXe+AjJzWT0hda/aev6kNJAvHblGmmAYXdYhrnQs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs =
    [
      libadwaita
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [ "-Wno-error=incompatible-function-pointer-types" ]
  );

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Preview and debug websites metadata tags for social media share";
    homepage = "https://apps.gnome.org/SharePreview";
    downloadPage = "https://github.com/rafaelmardojai/share-preview";
    changelog = "https://github.com/rafaelmardojai/share-preview/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "share-preview";
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.unix;
  };
})
