{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rocksdb_7_10,
}:

let
  rocksdb = rocksdb_7_10;
in
rustPlatform.buildRustPackage rec {
  pname = "electrs";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = "electrs";
    rev = "v${version}";
    hash = "sha256-Xo7aqP4tIh/kYthPucscxnl+ZtVioEja4TTFdH0Q350=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-wDEtVsgkddGv89tTy96wYzNWVicn34Gxi+YAo7yAfQA=";

  # needed for librocksdb-sys
  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  # link rocksdb dynamically
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    mainProgram = "electrs";
  };
}
