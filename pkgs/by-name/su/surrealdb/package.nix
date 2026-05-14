{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rocksdb,
  testers,
  protobuf,
  backend ? "rocksdb",
}:
let
  hasRocksDB = backend == "rocksdb";
in
assert lib.assertMsg (builtins.elem backend [
  "rocksdb"
  "surrealkv"
]) "surrealdb: backend must be one of [ \"rocksdb\" \"surrealkv\" ]";
rustPlatform.buildRustPackage (finalAttrs: {
  pname = if hasRocksDB then "surrealdb" else "surrealdb-surrealkv";
  version = "2.6.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dd6tabpSTh7IN9PLE4Zt/s1G7mNUwYfy+nEZpPTy8a8=";
  };

  cargoHash = "sha256-lebSQPGnxW+3a7vWw3R7QYtHx04/DsRK/n8c/UT3FZo=";

  # Upstream hard-codes `aarch64-linux-gnu-gcc` in `.cargo/config.toml`.
  # Remove it so Cargo uses nixpkgs' wrapped C toolchain instead.
  postPatch = ''
    rm .cargo/config.toml
  '';

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "allocator"
    "allocation-tracking"
    "http"
    "scripting"
    "storage-mem"
    "storage-surrealcs"
    # Keep this enabled for the default RocksDB build to preserve upstream's
    # default storage feature set. It can be dropped if `pkgs.surrealdb` is
    # intentionally slimmed to RocksDB-only in a later change.
    "storage-surrealkv"
  ]
  ++ lib.optional hasRocksDB "storage-rocksdb";

  env = {
    PROTOC = "${protobuf}/bin/protoc";
    PROTOC_INCLUDE = "${protobuf}/include";
  }
  // lib.optionalAttrs hasRocksDB {
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  checkFlags = [
    # requires docker
    "--skip=database_upgrade"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "surreal version";
  };

  meta = {
    description =
      if hasRocksDB then
        "Scalable, distributed, collaborative, document-graph database, for the realtime web"
      else
        "SurrealDB with the SurrealKV storage backend";
    homepage = "https://surrealdb.com/";
    mainProgram = "surreal";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      sikmir
      happysalada
      siriobalmelli
    ];
  };
})
