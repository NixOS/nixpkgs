{ lib
, cmake
, dbus
, fetchFromGitHub
, fetchYarnDeps
, openssl
, pkg-config
, freetype
, libsoup_2_4
, gtk3
, webkitgtk_4_0
, perl
, cyrus_sasl
, stdenv
, yarnConfigHook
, nodejs-slim
, cargo-tauri_1
, cargo
, rustPlatform
, rustc
, jq
, moreutils
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "insulator2";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "andrewinci";
    repo = pname;
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

  dontUseCmakeConfigure = true;

  preInstall = ''
    mkdir -p "$out"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri_1.hook
    yarnConfigHook
    nodejs-slim
    cyrus_sasl
    jq
    moreutils # for sponge
  ];

  buildInputs = [
    dbus
    openssl.out
    freetype
    libsoup_2_4
    gtk3
    webkitgtk_4_0
  ];

  meta = with lib; {
    description = "Client UI to inspect Kafka topics, consume, produce and much more";
    homepage = "https://github.com/andrewinci/insulator2";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tc-kaluza ];
    mainProgram = "insulator-2";
  };
}
