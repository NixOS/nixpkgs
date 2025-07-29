{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchYarnDeps,

  cargo,
  cargo-tauri_1,
  cmake,
  jq,
  moreutils,
  nodejs-slim,
  pkg-config,
  rustc,
  rustPlatform,
  yarnConfigHook,

  cyrus_sasl,
  freetype,
  libsoup_2_4,
  openssl,
  webkitgtk_4_0,
}:

stdenv.mkDerivation rec {
  pname = "insulator2";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "andrewinci";
    repo = "insulator2";
    rev = "v${version}";
    hash = "sha256-34JRIB7/x7miReWOxR/m+atjfUiE3XGyh9OBSbMg3m4=";
  };

  patches = [
    # see: https://github.com/andrewinci/insulator2/pull/733
    ./fix-rust-1.80.0.patch
  ];

  # Yarn *really* wants us to use corepack if this is set
  postPatch = ''
    jq 'del(.packageManager)' package.json | sponge package.json
  '';

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-5wOgVrcHJVF07QpnN52d4VWEM3FKw3NdLrZ1goAP2oI=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "apache-avro-0.16.0" = "sha256-v4TeJEhLEqQUgj+EHgFRVUGoLC+SpOUhAXngMP7R7nM=";
      "rust-keystore-0.1.1" = "sha256-Cj64uJFZNxnrplhRuqf9/HK/RAaawzfYHo/J9snZ+TU=";
    };
  };

  cargoRoot = "backend/";
  buildAndTestSubdir = cargoRoot;

  strictDeps = true;

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cargo
    cargo-tauri_1.hook
    cmake
    jq
    moreutils # for sponge
    nodejs-slim
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    yarnConfigHook
  ];

  buildInputs = [
    cyrus_sasl
    freetype
    libsoup_2_4
    openssl
    webkitgtk_4_0
  ];

  env.OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Client UI to inspect Kafka topics, consume, produce and much more";
    homepage = "https://github.com/andrewinci/insulator2";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tc-kaluza ];
    mainProgram = "insulator-2";
  };
}
