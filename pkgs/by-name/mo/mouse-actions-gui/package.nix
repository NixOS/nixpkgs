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
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "jersou";
    repo = "mouse-actions";
    rev = "v${finalAttrs.version}";
    hash = "sha256-02E4HrKIoBV3qZPVH6Tjz9Bv/mh5C8amO1Ilmd+YO5g=";
  };

  sourceRoot = "${finalAttrs.src.name}/config-editor";

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
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
    hash = "sha256-Rnr5jRupdUu6mIsWvdN6AnQnsxB5h31n/24pYslGs5g=";
  };

  cargoRoot = "src-tauri";

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.sourceRoot}/${finalAttrs.cargoRoot}";
    hash = "sha256-VQFRatnxzmywAiMLfkVgB7g8AFoqfWFYjt/vezpE1o8=";
  };

  buildPhase = ''
    runHook preBuild
    cargo-tauri build -b deb
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 ${./80-mouse-actions.rules} $out/etc/udev/rules.d/80-mouse-actions.rules
    cp -r src-tauri/target/release/bundle/deb/*/data/usr/* $out

    runHook postInstall
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
