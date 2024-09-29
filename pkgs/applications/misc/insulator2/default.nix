{ lib
, dbus
, fetchFromGitHub
, fetchYarnDeps
, openssl
, pkg-config
, freetype
, libsoup
, gtk3
, webkitgtk
, perl
, cyrus_sasl
, stdenv
, fixup-yarn-lock
, yarn
, nodejs-slim
, cargo-tauri
, cargo
, rustPlatform
, rustc
, jq
, moreutils
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

  # Yarn *really* wants us to use corepack if this is set
  postPatch = ''
    jq 'del(.packageManager)' package.json | sponge package.json
  '';

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-5wOgVrcHJVF07QpnN52d4VWEM3FKw3NdLrZ1goAP2oI=";
  };

  cargoHash = "";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "apache-avro-0.16.0" = "sha256-v4TeJEhLEqQUgj+EHgFRVUGoLC+SpOUhAXngMP7R7nM=";
      "rust-keystore-0.1.1" = "sha256-Cj64uJFZNxnrplhRuqf9/HK/RAaawzfYHo/J9snZ+TU=";
    };
  };

  configurePhase = ''
    export HOME=$(mktemp -d)
    export COREPACK_ROOT="true"
    export SKIP_YARN_COREPACK_CHECK="true"
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
    yarn run postinstall --offline
  '';

  preBuild = ''
    yarn tauri build -b deb
  '';

  cargoRoot = "backend/";
  buildAndTestDir = cargoRoot;

  nativeBuildInputs = [
    pkg-config
    perl
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
    fixup-yarn-lock
    yarn
    nodejs-slim
    cyrus_sasl
    jq
    moreutils # for sponge
  ];

  buildInputs = [
    dbus
    openssl.out
    freetype
    libsoup
    gtk3
    webkitgtk
  ];

  meta = with lib; {
    description = "Client UI to inspect Kafka topics, consume, produce and much more";
    homepage = "https://github.com/andrewinci/insulator2";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tc-kaluza ];
    mainProgram = "insulator-2";
  };

}
