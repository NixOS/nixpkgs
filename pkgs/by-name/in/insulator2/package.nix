{
  lib,
  cmake,
  dbus,
  fetchFromGitHub,
  fetchYarnDeps,
  openssl,
  pkg-config,
  freetype,
  libsoup_2_4,
  gtk3,
  webkitgtk_4_0,
  perl,
  cyrus_sasl,
  stdenv,
  yarnConfigHook,
  nodejs-slim,
  cargo-tauri_1,
  cargo,
  rustPlatform,
  rustc,
  jq,
  moreutils,
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
    # see https://github.com/andrewinci/insulator2/issues/735
    ./use-original-avro-crate.patch
  ];

  # Yarn *really* wants us to use corepack if this is set
  postPatch = ''
    jq 'del(.packageManager)' package.json | sponge package.json
  '';

  cargoRoot = "backend/";
  buildAndTestSubdir = cargoRoot;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      patches
      cargoRoot
      ;
    hash = "sha256-mq8xw1wdc6+Na2fPXWvZ+lIjtu76xIA3vK39hQBXQ3g=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-5wOgVrcHJVF07QpnN52d4VWEM3FKw3NdLrZ1goAP2oI=";
  };

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
