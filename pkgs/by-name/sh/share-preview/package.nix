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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "share-preview";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "share-preview";
    rev = finalAttrs.version;
    hash = "sha256-6Pk+3o4ZWF5pDYAtcBgty4b7edzIZnIuJh0KW1VW33I=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "share-preview-${finalAttrs.version}";
    hash = "sha256-MC5MsoFdeCvF9nIFoYCKoBBpgGysBH36OdmTqbIJt8s=";
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
