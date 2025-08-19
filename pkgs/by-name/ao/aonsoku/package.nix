{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  pnpm_8,
  pkg-config,
  wrapGAppsHook3,
  openssl,
  webkitgtk_4_1,
  glib-networking,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aonsoku";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "victoralvesf";
    repo = "aonsoku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qlc7P222e6prYG30iVTAZhP772za3H7gVszfWvOr2NM=";
  };

  # lockfileVersion: '6.0' need old pnpm
  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-h1rcM+H2c0lk7bpGeQT5ue9bQIggrCFHkj4o7KxnH08=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-8UtfL8iB1XKP31GT9Ok5hIQSobQTm681uiluG+IhK/s=";

  patches = [ ./remove_updater.patch ];

  nativeBuildInputs = [
    nodejs
    pnpm_8.configHook
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
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
