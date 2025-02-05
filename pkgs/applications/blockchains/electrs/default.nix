{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  rocksdb_7_10,
  Security,
}:

let
  rocksdb = rocksdb_7_10;
in
rustPlatform.buildRustPackage rec {
  pname = "electrs";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Xo7aqP4tIh/kYthPucscxnl+ZtVioEja4TTFdH0Q350=";
  };

  cargoHash = "sha256-T98nbf6j7hLRoCa38rN5KDYHqnGmAcVt9edwQ3cduKY=";

  # needed for librocksdb-sys
  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  # link rocksdb dynamically
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    mainProgram = "electrs";
  };
}
