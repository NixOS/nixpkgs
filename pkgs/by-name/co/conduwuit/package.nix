{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  zstd,
  stdenv,
  rocksdb,
  nix-update-script,
  testers,
  conduwuit,
  # upstream conduwuit enables jemalloc by default, so we follow suit
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
rustPlatform.buildRustPackage rec {
  pname = "conduwuit";
  version = "0.5.0-rc3";

  src = fetchFromGitHub {
    owner = "girlbossceo";
    repo = "conduwuit";
    tag = "v${version}";
    hash = "sha256-Etzh7m1aZBwKfcS6sa+2zBzdOaZSR+yFn2pwwGTilb4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GGCcYPYWkBVUD9wcSihv6q+J1kJisfETN5U0Q9V8p7Q=";

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
  # See https://github.com/girlbossceo/conduwuit/blob/main/src/main/Cargo.toml
  # for available features.
  # We enable all default features except jemalloc and io_uring, which
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
    ++ lib.optionals enableJemalloc [
      "jemalloc"
      "jemalloc_conf"
    ]
    ++ lib.optional enableLiburing "io_uring";

  passthru = {
    updateScript = nix-update-script { };
    tests =
      {
        version = testers.testVersion {
          inherit version;
          package = conduwuit;
        };
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux {
        inherit (nixosTests) conduwuit;
      };
  };

  meta = {
    description = "Matrix homeserver written in Rust, forked from conduit";
    homepage = "https://conduwuit.puppyirl.gay/";
    changelog = "https://github.com/girlbossceo/conduwuit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ niklaskorz ];
    mainProgram = "conduwuit";
  };
}
