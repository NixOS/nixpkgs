{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  sqlite,
  nixosTests,
  rocksdb,
  rust-jemalloc-sys,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-conduit";
  version = "0.10.17";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "conduit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PAMElavwXxI7XJoqTIrT2OFy3W9DS8Z5XoA0rFNzpUw=";
  };

  cargoHash = "sha256-QSDqJSctJCpQ2HLe69IJBcXPum4CptIDJjgRkgTN8Og=";

  # Conduit enables rusqlite's bundled feature by default, but we'd rather use our copy of SQLite.
  preBuild = ''
    substituteInPlace Cargo.toml --replace-fail "features = [\"bundled\"]" "features = []"
    cargo update --offline -p rusqlite
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    sqlite
    rust-jemalloc-sys
    rocksdb
  ];

  env = {
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  };

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      inherit (nixosTests) matrix-conduit;
    };
  };

  meta = {
    description = "Matrix homeserver written in Rust";
    homepage = "https://conduit.rs/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pstn
      SchweGELBin
      Kladki
    ];
    mainProgram = "conduit";
  };
})
