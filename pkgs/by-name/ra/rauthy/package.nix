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
  version = "0.30.0";
  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${version}";
    hash = "sha256-zmzo1GMy+5lUr53PhVqAdYQHMEPqBAp6M2SPocIMER0=";
  };
in
rustPlatform.buildRustPackage {
  pname = "rauthy";
  inherit version src;

  cargoPatches = [
    # otherwise it tries to download swagger-ui at build time
    ./0001-enable-vendored-feature-for-utoipa-swagger-ui.patch
  ];

  cargoHash = "sha256-hOBmyo4Jwmnbv1Eywepn6lJbUfonUSvDzxKOGY1yTM0=";

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
