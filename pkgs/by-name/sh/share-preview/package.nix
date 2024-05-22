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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "share-preview-${finalAttrs.version}";
    hash = "sha256-Gh6bQZD1mlkj3XeGp+fF/NShC4PZCZSEqymrsSdX4Ec=";
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

  buildInputs = [
    libadwaita
    openssl
  ];

  meta = {
    description = "Preview and debug websites metadata tags for social media share";
    homepage = "https://apps.gnome.org/SharePreview";
    license = lib.licenses.gpl3Plus;
    mainProgram = "share-preview";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
