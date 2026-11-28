{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  udev,
  udevCheckHook,
  webkitgtk_4_1,
  wrapGAppsHook4,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sharkfin";
  version = "0.12.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dniminenn";
    repo = "sharkfin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b8A5SIZTVGHl9dnN6AZFLpf+FlofSadUU9YWgnvp1b0=";
  };

  cargoRoot = "app/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-dE8sM1Yp+icq2sBayXrQ69q1q5byHMIhog+VQdCqG/Q=";

  npmRoot = "app";
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/app";
    hash = "sha256-RitzxFpewmJY0simfmvRqgmnVlQqrvkofuM40INtgIQ=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
    webkitgtk_4_1
  ];

  doInstallCheck = true;

  # Upstream does not specify a bundle category.
  postPatch = ''
    substituteInPlace app/src-tauri/tauri.conf.json \
      --replace-fail '"targets": "all",' '"targets": "all", "category": "Utility",'
  '';

  nativeInstallCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udevCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configurator for Attack Shark and other ROYUAN keyboards";
    homepage = "https://getsharkfin.com/";
    changelog = "https://github.com/dniminenn/sharkfin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "sharkfin";
    maintainers = [ lib.maintainers.jancopieters ];
  };
})
