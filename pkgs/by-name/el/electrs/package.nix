{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rocksdb_9_10,
}:

let
  rocksdb = rocksdb_9_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "electrs";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = "electrs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jsZ1rgIjw4M2IM57wJGk0MLV74npm51vAeunGTm/aCI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-0DfrN6LOT4FQ6nU1lRgwlDAP6EBtbUds4RrZTXkSgsI=";
  };

  # needed for librocksdb-sys
  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  env = {
    # link rocksdb dynamically
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
    mainProgram = "electrs";
  };
})
