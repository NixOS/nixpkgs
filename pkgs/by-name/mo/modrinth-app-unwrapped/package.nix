{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  buildGoModule,
  nix-update-script,
  cargo-tauri,
  desktop-file-utils,
  esbuild,
  darwin,
  libsoup,
  nodejs,
  openssl,
  pkg-config,
  pnpm_8,
  webkitgtk,
}:
rustPlatform.buildRustPackage rec {
  pname = "modrinth-app-unwrapped";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "theseus";
    rev = "v${version}";
    sha256 = "sha256-JWR0e2vOBvOLosr22Oo2mAlR0KAhL+261RRybhNctlM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-single-instance-0.0.0" = "sha256-Mf2/cnKotd751ZcSHfiSLNe2nxBfo4dMBdoCwQhe7yI=";
    };
  };

  pnpmDeps = pnpm_8.fetchDeps {
    inherit pname version src;
    sourceRoot = "${src.name}/theseus_gui";
    hash = "sha256-g/uUGfC9TQh0LE8ed51oFY17FySoeTvfaeEpzpNeMao=";
  };
  pnpmRoot = "theseus_gui";

  nativeBuildInputs = [
    cargo-tauri
    desktop-file-utils
    nodejs
    pnpm_8.configHook
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

  env = {
    tauriBundle =
      {
        Linux = "deb";
        Darwin = "app";
      }
      .${stdenv.hostPlatform.uname.system}
      or (throw "No tauri bundle available for ${stdenv.hostPlatform.uname.system}!");

    ESBUILD_BINARY_PATH = lib.getExe (
      esbuild.override {
        buildGoModule = args: buildGoModule (args // rec {
          version = "0.20.2";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-h/Vqwax4B4nehRP9TaYbdixAZdb1hx373dNxNHvDrtY=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        });
      }
    );
  };

  buildPhase = ''
    runHook preBuild

    cargo tauri build --bundles "$tauriBundle"

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
      cp -r target/release/bundle/"$tauriBundle"/*/data/usr "$out"
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
    homepage = "https://modrinth.com";
    changelog = "https://github.com/modrinth/theseus/releases/tag/v${version}";
    license = with lib.licenses; [
      gpl3Plus
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "modrinth-app";
    platforms = with lib; platforms.linux ++ platforms.darwin;
    # this builds on architectures like aarch64, but the launcher itself does not support them yet
    broken = !stdenv.isx86_64;
  };
}
