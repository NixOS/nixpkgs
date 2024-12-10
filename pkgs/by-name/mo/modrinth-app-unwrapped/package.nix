{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  rustPlatform,
  buildGoModule,
  nix-update-script,
  modrinth-app-unwrapped,
  cacert,
  cargo-tauri,
  desktop-file-utils,
  esbuild,
  darwin,
  jq,
  libsoup,
  moreutils,
  nodePackages,
  openssl,
  pkg-config,
  webkitgtk,
}:
rustPlatform.buildRustPackage {
  pname = "modrinth-app-unwrapped";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "theseus";
    rev = "v${modrinth-app-unwrapped.version}";
    sha256 = "sha256-JWR0e2vOBvOLosr22Oo2mAlR0KAhL+261RRybhNctlM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-single-instance-0.0.0" = "sha256-Mf2/cnKotd751ZcSHfiSLNe2nxBfo4dMBdoCwQhe7yI=";
    };
  };

  pnpm-deps = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "${modrinth-app-unwrapped.pname}-pnpm-deps";
    inherit (modrinth-app-unwrapped) version src;
    sourceRoot = "${finalAttrs.src.name}/theseus_gui";

    dontConfigure = true;
    dontBuild = true;
    doCheck = false;

    nativeBuildInputs = [
      cacert
      jq
      moreutils
      nodePackages.pnpm
    ];

    # https://github.com/NixOS/nixpkgs/blob/763e59ffedb5c25774387bf99bc725df5df82d10/pkgs/applications/misc/pot/default.nix#L56
    installPhase = ''
      export HOME=$(mktemp -d)

      pnpm config set store-dir "$out"
      pnpm install --frozen-lockfile --ignore-script --force

      # remove timestamp and sort json files
      rm -rf "$out"/v3/tmp
      for f in $(find "$out" -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . "$f" | sponge "$f"
      done
    '';

    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-g/uUGfC9TQh0LE8ed51oFY17FySoeTvfaeEpzpNeMao=";
  });

  nativeBuildInputs = [
    cargo-tauri
    desktop-file-utils
    nodePackages.pnpm
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
        or (builtins.throw "No tauri bundle available for ${stdenv.hostPlatform.uname.system}!");

    ESBUILD_BINARY_PATH = lib.getExe (
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
  };

  postPatch = ''
    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    pushd theseus_gui
    cp -rT ${modrinth-app-unwrapped.pnpm-deps} "$STORE_PATH"
    chmod -R +w "$STORE_PATH"

    pnpm config set store-dir "$STORE_PATH"
    pnpm install --offline --frozen-lockfile --ignore-script
    popd
  '';

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
    mainProgram = "modrinth-app";
    homepage = "https://modrinth.com";
    changelog = "https://github.com/modrinth/theseus/releases/tag/v${modrinth-app-unwrapped.version}";
    license = with lib.licenses; [
      gpl3Plus
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = with lib; platforms.linux ++ platforms.darwin;
    # this builds on architectures like aarch64, but the launcher itself does not support them yet
    broken = !stdenv.isx86_64;
  };
}
