{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  bzip2,
  zstd,
  stdenv,
  rocksdb,
  nix-update-script,
  testers,
  matrix-continuwuity,
  enableBlurhashing ? true,
  # upstream continuwuity enables jemalloc by default, so we follow suit
  enableJemalloc ? true,
  rust-jemalloc-sys,
  enableLiburing ? stdenv.hostPlatform.isLinux,
  liburing,
  nixosTests,
}:
let
  rust-jemalloc-sys' = rust-jemalloc-sys.override {
    unprefixed = !stdenv.hostPlatform.isDarwin;
  };
  rocksdb' = rocksdb.override {
    inherit enableLiburing;
    # rocksdb does not support prefixed jemalloc, which is required on darwin
    enableJemalloc = enableJemalloc && !stdenv.hostPlatform.isDarwin;
    jemalloc = rust-jemalloc-sys';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-continuwuity";
  version = "0.5.0-rc.5";

  src = fetchFromGitea {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "continuwuity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Oq2scBu3Ewao828BT1QGffqIqF5WoH9HMXEXKg1YU0o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bjjGR3++CaDEtlsQj9GgdViCEB5l72sI868uTFBtIwg=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      bzip2
      zstd
    ]
    ++ lib.optional enableJemalloc rust-jemalloc-sys'
    ++ lib.optional enableLiburing liburing;

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    ROCKSDB_INCLUDE_DIR = "${rocksdb'}/include";
    ROCKSDB_LIB_DIR = "${rocksdb'}/lib";
  };

  buildNoDefaultFeatures = true;
  # See https://forgejo.ellis.link/continuwuation/continuwuity/src/branch/main/Cargo.toml
  # for available features.
  # We enable all default features except jemalloc, blurhashing, and io_uring, which
  # we guard behind our own (default-enabled) flags.
  buildFeatures =
    [
      "brotli_compression"
      "element_hacks"
      "gzip_compression"
      "media_thumbnail"
      "release_max_log_level"
      "systemd"
      "url_preview"
      "zstd_compression"
    ]
    ++ lib.optional enableBlurhashing "blurhashing"
    ++ lib.optional enableJemalloc [
      "jemalloc"
      "jemalloc_conf"
    ]
    ++ lib.optional enableLiburing "io_uring";

  passthru = {
    updateScript = nix-update-script { };
    tests =
      {
        version = testers.testVersion {
          inherit (finalAttrs) version;
          package = matrix-continuwuity;
        };
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux {
        inherit (nixosTests) matrix-continuwuity;
      };
  };

  meta = {
    description = "Matrix homeserver written in Rust, forked from conduwuit";
    homepage = "https://continuwuity.org/";
    changelog = "https://forgejo.ellis.link/continuwuation/continuwuity/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nyabinary
      snaki
    ];
    # Not a typo, continuwuity is a drop-in replacement for conduwuit.
    mainProgram = "conduwuit";
  };
})
