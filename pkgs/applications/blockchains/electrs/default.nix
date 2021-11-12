{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, rocksdb
, Security
}:

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

  # temporarily disable dynamic linking, which broke with rocksdb update 6.23.3 -> 6.25.3
  # https://github.com/NixOS/nixpkgs/pull/143524#issuecomment-955053331
  #
  # link rocksdb dynamically
  # ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  # ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "An efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
