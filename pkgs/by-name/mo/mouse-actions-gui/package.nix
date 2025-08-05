{
  lib,
  fetchFromGitHub,

  npmHooks,
  fetchNpmDeps,
  nodejs,

  rustPlatform,
  cargo-tauri_1,

  pkg-config,
  wrapGAppsHook3,
  libXtst,
  libevdev,
  udevCheckHook,
  gtk3,
  libsoup_2_4,
  webkitgtk_4_0,
}:

rustPlatform.buildRustPackage rec {
  pname = "mouse-actions-gui";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "jersou";
    repo = "mouse-actions";
    tag = "v${version}";
    hash = "sha256-44F4CdsDHuN2FuijnpfmoFy4a/eAbYOoBYijl9mOctg=";
  };

  sourceRoot = "${src.name}/config-editor";

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
    cargo-tauri_1.hook
    pkg-config
    wrapGAppsHook3
    udevCheckHook
  ];

  buildInputs = [
    # Base deps
    libXtst
    libevdev

    # Tauri deps
    gtk3
    libsoup_2_4
    webkitgtk_4_0
  ];

  npmDeps = fetchNpmDeps {
    inherit src sourceRoot;
    hash = "sha256-amDTYAvEoDHb7+dg39+lUne0dv0M9vVe1vHoXk2agZA=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  cargoHash = "sha256-G5PQWPcPOVhq11BQIplbB3mLAGFCVm+vQ4eM4/5MFwI=";

  doInstallCheck = true;

  postInstall = ''
    install -Dm644 ${./80-mouse-actions.rules} $out/etc/udev/rules.d/80-mouse-actions.rules
  '';

  meta = {
    changelog = "https://github.com/jersou/mouse-actions/blob/${src.rev}/CHANGELOG.md";
    description = "Mouse event based command executor, a mix between Easystroke and Comiz edge commands";
    homepage = "https://github.com/jersou/mouse-actions";
    license = lib.licenses.mit;
    mainProgram = "mouse-actions-gui";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
}
