{
  lib,
  libiconv,
  fetchFromGitHub,
  copyDesktopItems,
  stdenv,
  rustc,
  rustPlatform,
  cargo,
  cargo-tauri,
  openssl,
  pkg-config,
  makeDesktopItem,
  pnpm,
  nodejs,
  darwin,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "en-croissant";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "franciscoBSalgueiro";
    repo = "en-croissant";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EiGML3oFCJR4TZkd+FekUrJwCYe/nGdWD9mAtKKtITQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  pnpmRoot = "..";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-hjSioKpvrGyo5UKvBrwln0S3aIpnJZ2PUdzBfbT7IC4=";
  };

  # pnpm.configHook has to write to .., as our sourceRoot is set to src-tauri
  preConfigure = ''
    chmod +w ..
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-log-0.0.0" = "sha256-t+zmMMSnD9ASZZvqlhu1ah2OjCUtRXdk/xaI37uI49c=";
      "vampirc-uci-0.11.1" = "sha256-g2JjHZoAmmZ7xsw4YnkUPRXJxsYmBqflWxCFkFEvMXQ=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
    nodejs
    pnpm.configHook
    copyDesktopItems
    pkg-config
  ];

  buildInputs =
    [
      libiconv
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Carbon
      darwin.apple_sdk.frameworks.Cocoa
      darwin.apple_sdk.frameworks.WebKit
    ];

  preBuild = ''
    cargo tauri build -b none
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv target/release/en-croissant $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "The Ultimate Chess Toolkit";
    homepage = "https://github.com/franciscoBSalgueiro/en-croissant";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "en-croissant";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
