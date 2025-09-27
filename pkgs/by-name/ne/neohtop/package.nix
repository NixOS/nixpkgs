{
  lib,
  stdenv,
  rustPlatform,
  cargo-tauri,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  pkg-config,
  webkitgtk_4_1,
  fetchFromGitHub,
  glib,
  gtk3,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neohtop";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Abdenasser";
    repo = "neohtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a6yHg3LqnVQJPi4+WpsxHjvWC2hZhZZkAFqgOVmfWfg=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-t0REXcsy9XIIARiI7lkOc5lO/ZSL50KOUK+SMsXpjdM=";
  };

  cargoPatches = [
    # Remove when https://github.com/Abdenasser/neohtop/pull/187 is released
    ./tauri-version.patch
  ];
  cargoHash = "sha256-fl/slVYr5RExI9ab8YeX2Q8mF+cnR1R1rUg5i11ao4M=";

  cargoRoot = "src-tauri";

  buildAndTestSubdir = "src-tauri";

  nativeBuildInputs = [
    cargo-tauri.hook
    npmHooks.npmConfigHook
    pkg-config
    nodejs
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib
    gtk3
    openssl
    webkitgtk_4_1
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blazing-fast system monitoring for your desktop";
    homepage = "https://github.com/Abdenasser/neohtop";
    changelog = "https://github.com/Abdenasser/neohtop/releases/tag/v${finalAttrs.version}";
    mainProgram = "NeoHtop";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ sandarukasa ];
  };
})
