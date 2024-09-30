{
  lib,
  stdenv,
  overrideSDK,
  rustPlatform,
  fetchFromGitHub,

  pnpm_9,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  makeBinaryWrapper,

  openssl,
  libsoup,
  webkitgtk,
  gst_all_1,
  darwin,
}:

let
  buildRustPackage = rustPlatform.buildRustPackage.override {
    stdenv = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
  };
in
buildRustPackage rec {
  pname = "en-croissant";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "franciscoBSalgueiro";
    repo = "en-croissant";
    rev = "refs/tags/v${version}";
    hash = "sha256-EiGML3oFCJR4TZkd+FekUrJwCYe/nGdWD9mAtKKtITQ=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-hjSioKpvrGyo5UKvBrwln0S3aIpnJZ2PUdzBfbT7IC4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-log-0.0.0" = "sha256-t+zmMMSnD9ASZZvqlhu1ah2OjCUtRXdk/xaI37uI49c=";
      "vampirc-uci-0.11.1" = "sha256-g2JjHZoAmmZ7xsw4YnkUPRXJxsYmBqflWxCFkFEvMXQ=";
    };
  };

  cargoRoot = "src-tauri";

  buildAndTestSubdir = cargoRoot;

  nativeBuildInputs =
    [
      pnpm_9.configHook
      nodejs
      cargo-tauri
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeBinaryWrapper ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      openssl
      libsoup
      webkitgtk
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-good
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk_11_0.frameworks.Cocoa
      darwin.apple_sdk_11_0.frameworks.WebKit
    ];

  # remove once cargo-tauri.hook becomes available
  # https://github.com/NixOS/nixpkgs/pull/335751
  buildPhase = ''
    runHook preBuild

    cargo tauri build --bundles ${if stdenv.hostPlatform.isDarwin then "app" else "deb"}

    runHook postBuild
  '';

  doCheck = false; # many scoring tests fail

  # remove once cargo-tauri.hook becomes available
  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out"/Applications
      cp -r src-tauri/target/release/bundle/macos/* "$out"/Applications
    ''}

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p "$out"
      cp -r src-tauri/target/release/bundle/deb/*/data/usr/* "$out"
    ''}

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper "$out"/Applications/en-croissant.app/Contents/MacOS/en-croissant $out/bin/en-croissant
  '';

  meta = {
    description = "Ultimate Chess Toolkit";
    homepage = "https://github.com/franciscoBSalgueiro/en-croissant/";
    license = lib.licenses.gpl3Only;
    mainProgram = "en-croissant";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
