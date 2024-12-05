{
  lib,
  stdenv,
  apple-sdk_11,
  cacert,
  cargo-tauri,
  desktop-file-utils,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  rustPlatform,
  turbo,
  webkitgtk_4_1,
}:

let
  pnpm = pnpm_9;
in
rustPlatform.buildRustPackage rec {
  pname = "modrinth-app-unwrapped";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "code";
    rev = "refs/tags/v${version}";
    hash = "sha256-DR1aPbSqAVhL/m/Maa3mPzNWwK4A1WvDd/PwEMVYn5g=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "wry-0.44.1" = "sha256-I1qkUVTu+Yqk1Imo1w5rG/lRSPLITF5BdcjBsPe+jXU=";
    };
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-murZ82LV2pGng/Cg08NoWr/mDIVECrf00utVrs6PKRg=";
  };

  nativeBuildInputs = [
    cacert # Required for turbo
    cargo-tauri.hook
    desktop-file-utils
    nodejs
    pkg-config
    pnpm.configHook
  ] ++ lib.optional stdenv.hostPlatform.isDarwin makeBinaryWrapper;

  buildInputs =
    [ openssl ]
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11
    ++ lib.optional stdenv.hostPlatform.isLinux webkitgtk_4_1;

  env = {
    TURBO_BINARY_PATH = lib.getExe turbo;
  };

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeBinaryWrapper "$out"/Applications/Modrinth\ App.app/Contents/MacOS/Modrinth\ App "$out"/bin/ModrinthApp
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      desktop-file-edit \
        --set-comment "Modrinth's game launcher" \
        --set-key="StartupNotify" --set-value="true" \
        --set-key="Categories" --set-value="Game;ActionGame;AdventureGame;Simulation;" \
        --set-key="Keywords" --set-value="game;minecraft;mc;" \
        --set-key="StartupWMClass" --set-value="ModrinthApp" \
        $out/share/applications/Modrinth\ App.desktop
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
    mainProgram = "ModrinthApp";
    platforms = with lib; platforms.linux ++ platforms.darwin;
    # This builds on architectures like aarch64, but the launcher itself does not support them yet.
    # Darwin is the only exception
    # See https://github.com/modrinth/code/issues/776#issuecomment-1742495678
    broken = !stdenv.hostPlatform.isx86_64 && !stdenv.hostPlatform.isDarwin;
  };
}
