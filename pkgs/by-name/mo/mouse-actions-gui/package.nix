{
  lib,
  stdenv,
  fetchFromGitHub,

  npmHooks,
  fetchNpmDeps,
  nodejs,

  rustPlatform,
  cargo,
  rustc,
  cargo-tauri,

  pkg-config,
  wrapGAppsHook3,
  libXtst,
  libevdev,
  gtk3,
  libsoup,
  webkitgtk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mouse-actions-gui";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "jersou";
    repo = "mouse-actions";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-44F4CdsDHuN2FuijnpfmoFy4a/eAbYOoBYijl9mOctg=";
  };

  sourceRoot = "${finalAttrs.src.name}/config-editor";

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    # Base deps
    libXtst
    libevdev

    # Tauri deps
    gtk3
    libsoup
    webkitgtk
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src sourceRoot;
    hash = "sha256-amDTYAvEoDHb7+dg39+lUne0dv0M9vVe1vHoXk2agZA=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.sourceRoot}/${finalAttrs.cargoRoot}";
    hash = "sha256-H8TMpYFJWp227jPA5H2ZhSqTMiT/U6pT6eLyjibuoLU=";
  };

  postInstall = ''
    install -Dm644 ${./80-mouse-actions.rules} $out/etc/udev/rules.d/80-mouse-actions.rules
  '';

  meta = {
    changelog = "https://github.com/jersou/mouse-actions/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Mouse event based command executor, a mix between Easystroke and Comiz edge commands";
    homepage = "https://github.com/jersou/mouse-actions";
    license = lib.licenses.mit;
    mainProgram = "mouse-actions-gui";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
