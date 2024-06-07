{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  buildGoModule,
  nix-update-script,
  modrinth-app-unwrapped,
  cargo-tauri,
  desktop-file-utils,
  esbuild,
  darwin,
  libsoup,
  pnpm_8,
  nodejs,
  openssl,
  pkg-config,
  webkitgtk_4_0,
}:
rustPlatform.buildRustPackage rec {
  pname = "modrinth-app-unwrapped";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "theseus";
    rev = "v${modrinth-app-unwrapped.version}";
    hash = "sha256-JWR0e2vOBvOLosr22Oo2mAlR0KAhL+261RRybhNctlM=";
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
    cargo-tauri.hook
    desktop-file-utils
    pnpm_8.configHook
    nodejs
    pkg-config
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

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
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
    changelog = "https://github.com/modrinth/theseus/releases/tag/v${modrinth-app-unwrapped.version}";
    license = with lib.licenses; [
      gpl3Plus
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # this builds on architectures like aarch64, but the launcher itself does not support them yet
    broken = !stdenv.hostPlatform.isx86_64;
  };
}
