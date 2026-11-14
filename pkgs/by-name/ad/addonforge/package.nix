{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook4,
  webkitgtk_4_1,
  glib-networking,
  librsvg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "addonforge";
  version = "0.3.0-b18";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Topher121";
    repo = "AddonForge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hAod8pVCJP/ytMm4oRj6srwb6xjGO4ceJgZvjMOmFcM=";
  };

  cargoHash = "sha256-CXtRuzhtnZcDTnkQB+onwm30gQRzTxVQGRp36l78iWc=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  preBuild = ''
    cp -r ui src-tauri/dist
  '';

  tauriBuildFlags = "-c ${./override-tauri.conf.json}";

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
    librsvg
  ];

  meta = with lib; {
    description = "World of Warcraft Forever add-on manager with a GUI";
    longDescription = "Small, private, open-source addon manager for WoW: Forever. No ads, no accounts, no telemetry. Installs straight from GitHub, Wago, WoWInterface and TukUI.";
    homepage = "https://github.com/Topher121/AddonForge";
    license = licenses.mit;
    maintainers = [ maintainers.Grizzlywer ];
    platforms = platforms.linux;
    mainProgram = "addonforge";
  };
})
