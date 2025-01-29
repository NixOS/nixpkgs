{
  callPackage,
  cargo-tauri,
  darwin,
  desktop-file-utils,
  glib-networking,
  gtk3,
  lib,
  libayatana-appindicator,
  libsoup_2_4,
  nodejs,
  openssl,
  perl,
  pkg-config,
  pnpm_9,
  rustPlatform,
  stdenv,
  webkitgtk_4_0,
}:
let
  hoppscotch = callPackage ./base.nix { };
in
rustPlatform.buildRustPackage {
  pname = "hoppscotch-desktop-unwrapped";
  inherit (hoppscotch) version;

  src = hoppscotch;

  cargoRoot = "packages/hoppscotch-selfhost-desktop/src-tauri";
  cargoHash = "sha256-N7Dm0pknmAJrgvlajTJ+KBsXmaJKylQ+qffuBTZ5U4w=";
  useFetchCargoVendor = true;

  # could not find `Cargo.toml` in `/build/source` or any parent directory.
  doCheck = false;

  nativeBuildInputs = [
    cargo-tauri
    desktop-file-utils
    nodejs
    perl
    pkg-config
    pnpm_9
    stdenv.cc.cc
  ];

  buildInputs =
    [
      glib-networking
      openssl
      stdenv.cc.cc.lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libayatana-appindicator
      libsoup_2_4
      gtk3
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
    tauriBundle =
      {
        Darwin = "app";
        Linux = "deb";
      }
      .${stdenv.hostPlatform.uname.system}
        or (throw "No tauri bundle available for ${stdenv.hostPlatform.uname.system}!");
  };

  buildPhase = ''
    runHook preBuild

    cd "$cargoRoot"

    echo 'Building hoppscotch-selfhost-desktop Tauri...'
    pnpm tauri build --bundles "$tauriBundle"
    echo 'Built hoppscotch-selfhost-desktop Tauri'

    runHook postBuild
  '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.isDarwin ''
      mkdir -p "$out"/bin
      cp -r target/release/bundle/macos "$out"/Applications
      mv "$out"/Applications/Hoppscotch.app/Contents/MacOS/Hoppscotch "$out"/bin/hoppscotch
      ln -s "$out"/bin/hoppscotch "$out"/Applications/Hoppscotch.app/Contents/MacOS/Hoppscotch
    ''
    + lib.optionalString stdenv.isLinux ''
      cp -r target/release/bundle/"$tauriBundle"/*/data/usr "$out"
      desktop-file-edit \
        --set-comment 'Hoppscotch' \
        --set-key='StartupNotify' --set-value='true' \
        --set-key='Categories' --set-value='Development;' \
        --set-key='Keywords' --set-value='api;rest;' \
        --set-key='StartupWMClass' --set-value='io.hoppscotch.desktop' \
        --add-mime-type='hoppscotch' \
        --add-mime-type='io.hoppscotch.desktop' \
        "$out"/share/applications/hoppscotch.desktop
    ''
    + ''
      runHook postInstall
    '';

  meta = hoppscotch.meta // {
    mainProgram = "hoppscotch";
  };
}
