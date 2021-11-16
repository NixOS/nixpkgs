{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, rocksdb_6_23
, Security
}:

let
  rocksdb = rocksdb_6_23;
in
rustPlatform.buildRustPackage rec {
  pname = "electrs";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dYKSc5fU66fu+GdTeWQBrIOJAiBGdYAOS7MCto98Xss=";
  };

  cargoHash = "sha256-M4H5tUbo1f18kk8S53saebSnZhZFr8udw41BUNJbQVI==";

  # needed for librocksdb-sys
  nativeBuildInputs = [ llvmPackages.clang ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # link rocksdb dynamically
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "An efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
