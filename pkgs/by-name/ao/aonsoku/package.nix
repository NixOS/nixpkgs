{
  lib,
  fetchFromGitHub,
  rustPlatform,

  cargo-tauri,
  nodejs,
  pnpm,

  pkg-config,
  wrapGAppsHook3,

  openssl,
  libsoup_2_4,
  webkitgtk_4_1,
  glib-networking,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aonsoku";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "victoralvesf";
    repo = "aonsoku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A1U1ubprwYJvyqTe5gVYTo8687sfP/76GfA+2EmtoCo=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-BMEBJRycmOgsI1loTPTNY1dVOJ0HTCnzg0QyNAzZMn4=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  useFetchCargoVendor = true;
  cargoHash = "sha256-yuKaf05bQFah3MTC0eF82pMmTJrllWfUKX3SdIWbPjM=";

  patches = [ ./remove_updater.patch ];

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    cargo-tauri.hook

    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    libsoup_2_4
    webkitgtk_4_1
    glib-networking
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern desktop client for Navidrome/Subsonic servers";
    homepage = "https://github.com/victoralvesf/aonsoku";
    changelog = "https://github.com/victoralvesf/aonsoku/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "Aonsoku";
  };
})
