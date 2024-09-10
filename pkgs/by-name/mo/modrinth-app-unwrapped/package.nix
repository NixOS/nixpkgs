{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  buildGoModule,
  nix-update-script,
  cargo,
  cargo-tauri,
  desktop-file-utils,
  esbuild,
  darwin,
  libsoup,
  pnpm_8,
  nodejs,
  openssl,
  pkg-config,
  webkitgtk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "modrinth-app-unwrapped";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "theseus";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-JWR0e2vOBvOLosr22Oo2mAlR0KAhL+261RRybhNctlM=";
  };

  pnpmRoot = "theseus_gui";

  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs) pname src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
    hash = "sha256-g/uUGfC9TQh0LE8ed51oFY17FySoeTvfaeEpzpNeMao=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-single-instance-0.0.0" = "sha256-Mf2/cnKotd751ZcSHfiSLNe2nxBfo4dMBdoCwQhe7yI=";
    };
  };

  nativeBuildInputs = [
    pnpm_8.configHook
    nodejs

    rustPlatform.cargoSetupHook
    cargo
    cargo-tauri

    desktop-file-utils
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      libsoup
      webkitgtk
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        CoreServices
        Security
        WebKit
      ]
    );

  env.ESBUILD_BINARY_PATH = lib.getExe (
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args
          // rec {
            version = "0.20.2";
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-h/Vqwax4B4nehRP9TaYbdixAZdb1hx373dNxNHvDrtY=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        );
    }
  );

  buildPhase = ''
    runHook preBuild

    cargo tauri build --bundles ${if stdenv.isDarwin then "app" else "deb"}

    runHook postBuild
  '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.isDarwin ''
      mkdir -p "$out"/bin
      cp -r target/release/bundle/macos "$out"/Applications
      mv "$out"/Applications/Modrinth\ App.app/Contents/MacOS/Modrinth\ App "$out"/bin/modrinth-app
      ln -s "$out"/bin/modrinth-app "$out"/Applications/Modrinth\ App.app/Contents/MacOS/Modrinth\ App
    ''
    + lib.optionalString stdenv.isLinux ''
      cp -r target/release/bundle/deb/*/data/usr "$out"
      desktop-file-edit \
        --set-comment "Modrinth's game launcher" \
        --set-key="StartupNotify" --set-value="true" \
        --set-key="Categories" --set-value="Game;ActionGame;AdventureGame;Simulation;" \
        --set-key="Keywords" --set-value="game;minecraft;mc;" \
        --set-key="StartupWMClass" --set-value="ModrinthApp" \
        $out/share/applications/modrinth-app.desktop
    ''
    + ''
      runHook postInstall
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
    mainProgram = "modrinth-app";
    homepage = "https://modrinth.com";
    changelog = "https://github.com/modrinth/theseus/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # this builds on architectures like aarch64, but the launcher itself does not support them yet
    broken = !stdenv.isx86_64;
  };
})
