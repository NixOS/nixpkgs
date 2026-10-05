{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  sqlite,
  stdenv,
  nixosTests,
  rocksdb,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-conduit";
  version = "0.10.14";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "conduit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A7Gryk1ZWDu751n3rBfv9HUTiokoGhBol/ve9mWwRjA=";
  };

  cargoHash = "sha256-afYD2cR6VyFSa1M33ktuNcg2/r/Ag3HNKSz95gRCwuE=";

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

  # tests failed on x86_64-darwin with SIGILL: illegal instruction
  doCheck = !(stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin);

  passthru.tests = {
    inherit (nixosTests) matrix-conduit;
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
