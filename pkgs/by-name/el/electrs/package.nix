{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rocksdb_7_10,
}:

let
  rocksdb = rocksdb_7_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "electrs";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = "electrs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FSsTo2m88U7t6wMXaSuYhF5bCMRq11EBQsq6uiMdF7c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-hVPtnMqaFH+1QJ52ZG9vZ3clsMTsEpvF5JjTKWoKSPE=";
  };

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
})
