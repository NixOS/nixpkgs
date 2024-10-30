{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  cargo-tauri,
  darwin,
  desktop-file-utils,
  libsoup,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  turbo,
  webkitgtk_4_0,
}:

let
  pnpm = pnpm_9;
in
rustPlatform.buildRustPackage rec {
  pname = "modrinth-app-unwrapped";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "code";
    rev = "a0bd011b808cdc998ef27960f610a8d99550c914";
    hash = "sha256-zpFJq7if5gOx7jvwpE73lqH4Vpif0MJMPIGsgtThKVk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "sqlx-0.8.0-alpha.0" = "sha256-M1bumCMTzgDcQlgSYB6ypPp794e35ZSQCLzkbrFV4qY=";
      "tauri-plugin-single-instance-0.0.0" = "sha256-DZWTO2/LevbQJCJbeHbTc2rhesV3bNrs+BoYm2eMakA=";
    };
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-Ye9GHvkO+xZj87NIc1JLmhIJFqdkJMg7HvfTltx9krw=";
  };

  nativeBuildInputs = [
    cacert # required for turbo
    cargo-tauri.hook
    desktop-file-utils
    nodejs
    pkg-config
    pnpm.configHook
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libsoup
      webkitgtk_4_0
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        CoreServices
        Security
        WebKit
      ]
    );

  env = {
    TURBO_BINARY_PATH = lib.getExe turbo;
  };

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out"/bin
      mv "$out"/Applications/Modrinth\ App.app/Contents/MacOS/Modrinth\ App "$out"/bin/modrinth-app
      ln -s "$out"/bin/modrinth-app "$out"/Applications/Modrinth\ App.app/Contents/MacOS/Modrinth\ App
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      desktop-file-edit \
        --set-comment "Modrinth's game launcher" \
        --set-key="StartupNotify" --set-value="true" \
        --set-key="Categories" --set-value="Game;ActionGame;AdventureGame;Simulation;" \
        --set-key="Keywords" --set-value="game;minecraft;mc;" \
        --set-key="StartupWMClass" --set-value="ModrinthApp" \
        $out/share/applications/modrinth-app.desktop
    '';

  meta = {
    description = "Modrinth's game launcher";
    longDescription = ''
      A unique, open source launcher that allows you to play your favorite mods,
      and keep them up to date, all in one neat little package
    '';
    homepage = "https://modrinth.com";
    license = with lib.licenses; [
      gpl3Plus
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "modrinth-app";
    platforms = with lib; platforms.linux ++ platforms.darwin;
    # This builds on architectures like aarch64, but the launcher itself does not support them yet.
    # Darwin is the only exception
    # See https://github.com/modrinth/code/issues/776#issuecomment-1742495678
    broken = !stdenv.hostPlatform.isx86_64 && !stdenv.hostPlatform.isDarwin;
  };
}
