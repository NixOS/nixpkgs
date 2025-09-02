{
  lib,
  fetchFromGitHub,
  rustPlatform,
  rocksdb_9_10,
  pkg-config,
  perl,
  openssl,
  nix-update-script,
}:

let
  version = "0.28.0";
  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${version}";
    hash = "sha256-vrkU5yTXx8GC1HLNhxsk1VTTiWY8Aqn5MjyUspNOmq0=";
  };
in
rustPlatform.buildRustPackage {
  pname = "rauthy";
  inherit version src;

  cargoPatches = [
    # otherwise it tries to download swagger-ui at build time
    ./0002-enable-vendored-feature-for-utoipa-swagger-ui.patch
  ];

  cargoHash = "sha256-BUtycGKWV0KOxUjeDO+yl+OvIdIDiObsLWZ0rsS1Pg4=";

  ROCKSDB_INCLUDE_DIR = "${rocksdb_9_10}/include";
  ROCKSDB_LIB_DIR = "${rocksdb_9_10}/lib";

  nativeBuildInputs = [
    pkg-config
    perl
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];

  # tests take long, require the app and a database to be running, and some of them fail
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/sebadob/rauthy/releases/tag/v${version}";
    description = "OpenID Connect Single Sign-On Identity & Access Management";
    license = lib.licenses.asl20;
    mainProgram = "rauthy";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = with lib.platforms; linux;
  };
}
