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
  version = "2026-10-pre";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "Chfkch";
    repo = "bitritter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oGckLZxCtUWW+o6QKoQUrzb1C0LJny91M0vlz6PaajY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-tzR9auHlW42a7L8fd7tbx2wiulRu9qN8sgUwuYBhXuk=";
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
    changelog = "https://codeberg.org/Chfkch/bitritter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Cameo007
    ];
    mainProgram = "bitritter";
    platforms = lib.platforms.linux;
  };
})
