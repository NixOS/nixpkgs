{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  cargo-tauri,
  nodejs_24,
  pnpm_11,
  pnpmConfigHook,
  pkg-config,
  lld,
  wasm-pack,
  wrapGAppsHook3,
  webkitgtk_4_1,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openhome";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "andrewbenington";
    repo = "OpenHome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oFEVQrwyUpob/IhfCgzYgbEMy10zP/I3c/pbkWl1B7Y=";
  };

  cargoHash = "sha256-/99xHv/5A5l2sGAhmR2qz62HqTNRpX9G0jzL0E8scLg=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-RDSbvjbageRZBUmmFrG5qT4azz8ctloANQvjoZrvydo=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs_24
    pnpm_11
    pnpmConfigHook
    pkg-config
    lld
    wasm-pack
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    webkitgtk_4_1
  ];

  cargoRoot = ".";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for moving Pokémon between game saves";
    homepage = "https://github.com/andrewbenington/OpenHome";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ evanp ];
    mainProgram = "OpenHome";
    platforms = lib.platforms.all;
  };
})
