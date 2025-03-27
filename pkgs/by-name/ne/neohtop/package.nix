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
  libsoup_2_4,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neohtop";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Abdenasser";
    repo = "neohtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5hDxMQlDPXf0llu51Hwb/9n0GX0YSvVJUS+RvEiLsnM=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-qhAdKLtTQ2iUFc7UNJNeB1Mzbzg/NrGAWrKQTdGiN4Y=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-nYBPvfBzRIJdvfuOZnzs+kuSozlkBB/ImqjDYfvNBrA=";

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
    libsoup_2_4
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
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
