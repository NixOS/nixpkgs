{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, rocksdb_8_3
, testers
, surrealdb
, darwin
, protobuf
}:

let
  rocksdb = rocksdb_8_3;
in
rustPlatform.buildRustPackage rec {
  pname = "surrealdb";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    rev = "v${version}";
    hash = "sha256-KtR+qU2Xys4NkEARZBbO8mTPa7EI9JplWvXdtuLt2vE=";
  };

  cargoHash = "sha256-b0KmL6RQevO7oLPZCgUc4EUkgv99DbMFD/RkE/fwAHw=";

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

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  doCheck = false;

  checkFlags = [
    # flaky
    "--skip=ws_integration::none::merge"
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
    maintainers = with maintainers; [ sikmir happysalada ];
  };
}
