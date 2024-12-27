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
  darwin,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "restic-browser";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "emuell";
    repo = "restic-browser";
    rev = "v${version}";
    hash = "sha256-KE9pa4P6WyzNo3CxPKgREb6EEkUEQSuhihn938XN45A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-window-state-0.1.1" = "sha256-Mf2/cnKotd751ZcSHfiSLNe2nxBfo4dMBdoCwQhe7yI=";
    };
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps-${version}";
    inherit src;
    hash = "sha256-OhJQ+rhtsEkwrPu+V6ITkXSJT6RJ8pYFATo0VfJaijc=";
  };

  nativeBuildInputs =
    [
      cargo-tauri_1.hook

      nodejs
      npmHooks.npmConfigHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pkg-config
      wrapGAppsHook3
    ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      webkitgtk_4_0
      dbus
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        WebKit
      ]
    );

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    ln -s $out/Applications/Restic-Browser.app/Contents/MacOS/Restic-Browser $out/bin/${meta.mainProgram}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A GUI to browse and restore restic backup repositories";
    homepage = "https://github.com/emuell/restic-browser";
    changelog = "https://github.com/emuell/restic-browser/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ js6pak ];
    mainProgram = "restic-browser";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
