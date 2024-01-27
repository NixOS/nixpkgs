{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, rocksdb_7_10
, Security
}:

let
  rocksdb = rocksdb_7_10;
in
rustPlatform.buildRustPackage rec {
  pname = "electrs";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cRnCo/N0k5poiOh308Djw6bySFQFIY3GiD2qjRyMjLM=";
  };

  cargoHash = "sha256-fsYJ+80se5VsIaRkFgwJaPPgRw/WdsecRTt6EIjoQTQ=";

  # needed for librocksdb-sys
  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  # link rocksdb dynamically
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "An efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    mainProgram = "electrs";
  };
}
