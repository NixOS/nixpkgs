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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "share-preview-${finalAttrs.version}";
    hash = "sha256-XY48fQ5HLvZ1nxLk6rbuxSBAHAPUcnwu/5AwgTWhfbg=";
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
    license = lib.licenses.gpl3Plus;
    mainProgram = "share-preview";
    maintainers = lib.teams.gnome-circle.members;
    platforms = lib.platforms.unix;
  };
})
