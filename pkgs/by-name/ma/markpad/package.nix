{
  lib,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  stdenv,
  wrapGAppsHook4,
  glib-networking,
  openssl,
  webkitgtk_4_1,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "markpad";
  version = "2.7.6";

  cargoHash = "sha256-OUC6BxiyXb/Uhjam9MvV4GkABv122M4J+/OrNLP8D30=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-pyU3Jb5Qy0xx3OHp+jeZEGeOIyKF77W0DSSIRsb7f1M=";
  };

  src = fetchFromGitHub {
    owner = "sftwrdotdev";
    repo = "Markpad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-baxW7kkBw3IfHD1oCPq5Ny88l0rNXGjHIetH3TT+xWc=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    npmHooks.npmConfigHook

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  cargoRoot = "src-tauri";
  tauriBuildFlags = "--no-sign";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A lightweight, minimalist Markdown viewer and text editor built for productivity across Windows, macOS, and Linux.";
    homepage = "https://github.com/sftwrdotdev/Markpad";
    changelog = "https://github.com/sftwrdotdev/Markpad/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hubble ];
    mainProgram = "markpad";
    platforms = [ "x86_64-linux" ];
  };
})
