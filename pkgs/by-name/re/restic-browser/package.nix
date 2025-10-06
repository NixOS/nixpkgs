{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri_1,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,
  webkitgtk_4_0,
  dbus,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "restic-browser";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "emuell";
    repo = "restic-browser";
    rev = "v${version}";
    hash = "sha256-magf19hA5PVAZafRcQXFaAD50qGofztpiluVc2aCeOk=";
  };

  cargoHash = "sha256-5wSxa8jgto+v+tJHbenc2nvGlLaOBYyRrCqFyCPnncc=";

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps-${version}";
    inherit src;
    hash = "sha256-U82hVPfVd12vBeDT3PHexwmc9OitkuxTugYRe4Z/3eo=";
  };

  nativeBuildInputs = [
    cargo-tauri_1.hook

    nodejs
    npmHooks.npmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_0
    dbus
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
