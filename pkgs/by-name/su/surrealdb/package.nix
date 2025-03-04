{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rocksdb,
  testers,
  surrealdb,
  darwin,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "surrealdb";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    tag = "v${version}";
    hash = "sha256-MzVyzhZ9BNxavlyj3E1D9Mo2/o6Yue21FdhpT8ziXwE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Uza2Ujg8EKGJrzitch71qIevgUv+n3YCtkMLHIAgPr4=";

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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

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
