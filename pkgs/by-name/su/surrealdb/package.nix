{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rocksdb,
  testers,
  protobuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "surrealdb";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SDzj/viDcuGbJ8HM0/KXBOjpc5vnreobTx0U3eNeKo8=";
  };

  cargoHash = "sha256-alxRXeeeIxi9lb5sIOU15nCD6A/B3ba5iouOTKRTe+w=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  env = {
    PROTOC = "${protobuf}/bin/protoc";
    PROTOC_INCLUDE = "${protobuf}/include";

    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";

    RUSTFLAGS = "--cfg surrealdb_unstable";
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
    description = "Scalable, distributed, collaborative, document-graph database, for the realtime web";
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
