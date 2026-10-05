{
  lib,
  stdenv,
  fetchFromCodeberg,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,
  meson,
  ninja,
  rustc,
  cargo,
  desktop-file-utils,
  openssl,
  libadwaita,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bitritter";
  version = "bfeffc8cd2";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "Chfkch";
    repo = "bitritter";
    rev = finalAttrs.version;
    hash = "sha256-sf5WdG3a76hxr4SAGjUmGFi+HxnRxQd66vHbUNkYO2k=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-y6Xl9FgCxbBmBItMGGWDLlbqLulbdTQaKZzwx807SMc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    meson
    ninja
    rustPlatform.cargoSetupHook
    rustc
    cargo
    desktop-file-utils
    openssl
  ];

  buildInputs = [
    openssl
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Bitwarden compatible client designed for mobile Linux ";
    homepage = "https://bitritter.dev/";
    # changelog = "https://codeberg.org/Chfkch/bitritter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Cameo007
    ];
    mainProgram = "bitritter";
    platforms = lib.platforms.linux;
  };
})
