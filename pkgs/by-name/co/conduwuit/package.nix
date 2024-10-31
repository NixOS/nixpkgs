{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  zstd,
  stdenv,
  darwin,
  rocksdb,
  nix-update-script,
  testers,
  conduwuit,
  # upstream conduwuit enables jemalloc by default, so we follow suit
  enableJemalloc ? true,
  rust-jemalloc-sys,
  enableLiburing ? stdenv.hostPlatform.isLinux,
  liburing,
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
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "girlbossceo";
    repo = "conduwuit";
    rev = "v${version}";
    hash = "sha256-ut3IWEueNR/hT7NyGfuK5IYtppC6ArSoJdEfFuD/0vE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ruma-0.10.1" = "sha256-u4C2VwRBmw8iVaPrkSmF/EKi5U3nWJWVktUDFmQcI1E=";
      "rust-librocksdb-sys-0.25.0+9.5.2" = "sha256-wz6QDLoXtY8+EU2DlPf4MbWC67KJK0hZnRswCeomkLQ=";
      "rustyline-async-0.4.3" = "sha256-7yYOGZ14SODD4+e9fTGgggUKqTi31479S0lEVKTKLPI=";
      "tikv-jemalloc-ctl-0.6.0" = "sha256-guiH6Gw/Oeb6A8Ri1SFcB6CW6mt+9XeA6vfwdS72yDQ=";
      "tracing-0.1.40" = "sha256-J6+8hBC/755SU8n1fTiJwBh17Unluv1SXfd5+dDAEhk=";
    };
  };

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
    ++ lib.optional enableLiburing liburing
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

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
  buildFeatures = [
    "brotli_compression"
    "element_hacks"
    "gzip_compression"
    "release_max_log_level"
    "sentry_telemetry"
    "systemd"
    "zstd_compression"
  ] ++ lib.optional enableJemalloc "jemalloc" ++ lib.optional enableLiburing "io_uring";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = conduwuit;
      version = "${version}";
    };
  };

  meta = {
    description = "Matrix homeserver written in Rust, forked from conduit";
    homepage = "https://conduwuit.puppyirl.gay/";
    changelog = "https://github.com/girlbossceo/conduwuit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ niklaskorz ];
    # Not a typo, conduwuit is a drop-in replacement for conduit.
    mainProgram = "conduit";
  };
}
