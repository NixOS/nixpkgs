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
  wrapGAppsHook3,
  webkitgtk_4_1,
  dbus,
  nix-update-script,
  restic,
}:
rustPlatform.buildRustPackage rec {
  pname = "restic-browser";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "emuell";
    repo = "restic-browser";
    rev = "v${version}";
    hash = "sha256-K8JEt1kOvu/G3S1O6W/ee2JM968bgPR/FeGaBKP6elU=";
  };

  cargoHash = "sha256-/EgSr46mJV84s/MG/3nUnU6XQ8RtEWiWo0gFtegblEQ=";

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps-${version}";
    inherit src;
    hash = "sha256-uyn5cXMKm7+LLuF+n94pBTypLiPvfAs5INDEtd9cHs0=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    npmHooks.npmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
    dbus
    restic
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    ln -s $out/Applications/Restic-Browser.app/Contents/MacOS/Restic-Browser $out/bin/${meta.mainProgram}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI to browse and restore restic backup repositories";
    homepage = "https://github.com/emuell/restic-browser";
    changelog = "https://github.com/emuell/restic-browser/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ js6pak ];
    mainProgram = "restic-browser";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
