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
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KDl+SV5U2aqsl3UMK8WWZiwkcqLpaRGmH/J8vBKTZcQ=";
  };

  cargoHash = "sha256-vcn+94KklWlYQw4fbH8KxhBnovk0dJc8Hkj+jJ+SeB0=";

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
