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
, fixup_yarn_lock
, yarnConfigHook
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
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "andrewinci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Bi9GCQr7yox5Plc7o0svRKYi1XoK/HDGj1VbW1z4jac=";
  };

  # Yarn *really* wants us to use corepack if this is set
  postPatch = ''
    jq 'del(.packageManager)' package.json | sponge package.json
  '';

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-ih5NSOvYje981SkVfPHm/u2sS1B36kgxpfe9LmQaxdo=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "apache-avro-0.15.0" = "sha256-bjA/x/IDzAYugsc1vn9fBVKaCiLOJYdA1Q9H2pffBh0=";
      "openssl-src-111.25.0+1.1.1t" = "sha256-1BEtb38ilJJAw35KW+NOIe1rhxxOPsnz0gA2zJnof8c=";
      "rdkafka-0.29.0" = "sha256-a739Fc+qjmIrK754GT22Gb/Ftd82lLSUzv53Ej7Khu4=";
      "rust-keystore-0.1.1" = "sha256-Cj64uJFZNxnrplhRuqf9/HK/RAaawzfYHo/J9snZ+TU=";
    };
  };

  cargoRoot = "backend/";
  buildAndTestDir = cargoRoot;

  nativeBuildInputs = [
    pkg-config
    perl
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri.hook
    fixup_yarn_lock
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
