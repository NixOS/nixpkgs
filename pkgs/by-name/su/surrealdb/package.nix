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
  version = "3.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KDVc5BTkJ5OwxANeXOBnerJihnKU6y72Dw8h1ARcj3U=";
  };

  cargoHash = "sha256-yemnwhcC5CsQgO29Qiau39QAVbGnrNsOG1dNen987HM=";

  # Upstream hard-codes `aarch64-linux-gnu-gcc` in `.cargo/config.toml`.
  # Remove it so Cargo uses nixpkgs' wrapped C toolchain instead.
  postPatch = ''
    rm .cargo/config.toml
    sed -i '1i #![recursion_limit = "256"]' surrealdb/server/src/lib.rs
  '';

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "allocator"
    "allocation-tracking"
    "http"
    "scripting"
    "storage-mem"
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
      aln730
      sikmir
      happysalada
      siriobalmelli
    ];
  };
})
