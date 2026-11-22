{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  rocksdb_9_10,
  zstd,
}:

let
  rocksdb = rocksdb_9_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "electrs";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = "electrs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z/Pl3AGXGU6WY/mre1rH4UXQ5qaaYv1Bbi9qpYQxsUA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-8UFZSg2nOjIBJ0dtudNh4Lo/AZFkq5BxN9GSI6eFd/Q=";
  };

  # needed for librocksdb-sys
  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ zstd ];

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
