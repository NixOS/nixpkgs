{
  cargo-tauri,
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nix-update-script,
  nodejs,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
  yarnConfigHook,
}:

rustPlatform.buildRustPackage (rec {
  pname = "headphones-toolbox";
  version = "0.0.7";
  tag = "test-tauri-v2-2";

  src = fetchFromGitHub {
    owner = "george-norton";
    repo = "headphones-toolbox";
    rev = "${tag}";
    hash = "sha256-X2HTEPxvBzbhfN1vqQVk81Qk1Z+EV+7/SpjZrDHv+fM=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-Ln5U0KKsKm6ZLViZIWfBiBjm/mQNEIxaj4nTR55PcRg=";
  };

  cargoHash = "sha256-VgCxYYNBV45sTzouS5NE7nOUViPj0gJO7DSKlJSAT4U=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pkg-config
    wrapGAppsHook3
    yarnConfigHook
  ];

  buildInputs = [ webkitgtk_4_1 ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UI for configuring Ploopy Headphones";
    homepage = "https://github.com/ploopyco/headphones-toolbox/";
    license = lib.licenses.gpl3Only;
    mainProgram = "headphones-toolbox";
    maintainers = with lib.maintainers; [
      flacks
      knarkzel
      nyabinary
    ];
    platforms = lib.platforms.linux;
  };
})
