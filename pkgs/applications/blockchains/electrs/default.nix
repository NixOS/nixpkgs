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
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GV/cwFdYpXJXRTgdVfuzJpmwNhe0kVJnYAJe+DPmRV8=";
  };

  cargoHash = "sha256-eQAizO26oQRosbMGJLwMmepBN3pocmnbc0qsHsAJysg=";

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
  };
}
