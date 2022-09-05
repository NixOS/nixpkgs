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
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jU0qN+T5bHn9l/SXDR/Wa8uCGyJhIDUCHzEQe39L2MQ=";
  };

  cargoHash = "sha256-hdScQd0Fd6gE9/f4kk0zjZLK42oK1aaDzIOcAIsJqbU=";

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
