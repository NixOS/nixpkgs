{
  lib,
  stdenv,
  cacert,
  cargo-tauri,
  desktop-file-utils,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  rustPlatform,
  turbo,
  webkitgtk_4_1,
  jdk,
  gradle,
}:

let
  pnpm = pnpm_9;
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "modrinth-app-unwrapped";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XfJbjbVcP9N3exAhXQoMGpoHORpKAlb0dPhQq195roY=";
  };

  patches = [ ./0001-build-script.patch ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-jWMHii65hTnTmiBFHxZ4xO5V+Qt/MPCy75eJvnlyE4c=";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-7iqXuIQPbP2p26vrWDjMoyZBPpbVQpigYAylhIg8+ZY=";
  };

  nativeBuildInputs = [
    cacert # Required for turbo
    cargo-tauri.hook
    desktop-file-utils
    nodejs
    pkg-config
    pnpm.configHook
    jdk
    gradle
  ] ++ lib.optional stdenv.hostPlatform.isDarwin makeBinaryWrapper;

  buildInputs = [ openssl ] ++ lib.optional stdenv.hostPlatform.isLinux webkitgtk_4_1;

  # Tests fail on other, unrelated packages in the monorepo
  cargoTestFlags = [
    "--package"
    "theseus_gui"
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true;
  gradleFlags = [ "--no-configuration-cache" ];
  preGradleUpdate = "cd packages/app-lib/java";
  dontUseGradleBuild = true;
  dontUseGradleCheck = true;

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

  passthru = {
    updateScript = nix-update-script { };
  };

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
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "ModrinthApp";
    platforms = with lib; platforms.linux ++ platforms.darwin;
    # This builds on architectures like aarch64, but the launcher itself does not support them yet.
    # Darwin is the only exception
    # See https://github.com/modrinth/code/issues/776#issuecomment-1742495678
    broken = !stdenv.hostPlatform.isx86_64 && !stdenv.hostPlatform.isDarwin;
  };
})
