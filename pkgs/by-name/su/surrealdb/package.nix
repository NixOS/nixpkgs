{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rocksdb,
  testers,
  surrealdb,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "surrealdb";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    tag = "v${version}";
    hash = "sha256-7Rv57D966TQFHbZKmtnt1XWuNOwD+r175iUVJiVho/0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JENp5g1as1RS9fdV5qepEAhE9/SJ8lbMiwyk3YDeu5k=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  RUSTFLAGS = "--cfg surrealdb_unstable";

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
    package = surrealdb;
    command = "surreal version";
  };

  meta = with lib; {
    description = "Scalable, distributed, collaborative, document-graph database, for the realtime web";
    homepage = "https://surrealdb.com/";
    mainProgram = "surreal";
    license = licenses.bsl11;
    maintainers = with maintainers; [
      sikmir
      happysalada
      siriobalmelli
    ];
  };
}
