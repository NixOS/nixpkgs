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
  matrix-tuwunel,
  enableBlurhashing ? true,
  # upstream tuwunel enables jemalloc by default, so we follow suit
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
  # tuwunel uses a modified version of rocksdb.  The following overrides take a lot from the
  # official flake:
  # https://github.com/matrix-construct/tuwunel/blob/main/flake.nix#L54
  rocksdb' =
    (rocksdb.override {
      inherit enableLiburing;
      # rocksdb does not support prefixed jemalloc, which is required on darwin
      enableJemalloc = enableJemalloc && !stdenv.hostPlatform.isDarwin;
      jemalloc = rust-jemalloc-sys';
    }).overrideAttrs
      (
        final: old: {
          src = fetchFromGitHub {
            owner = "matrix-construct";
            repo = "rocksdb";
            # The commit on the rocksdb fork, tuwunel-changes branch referenced by the upstream
            # tuwunel flake.lock:
            # https://github.com/matrix-construct/tuwunel/blob/main/flake.lock#L557C17-L557C57
            rev = "cf7f65d0b377af019661c240f9165b3ef60640c3";
            hash = "sha256-ZSjvAZBfZkJrBIpw8ANZMbJVb8AeuogvuAipGVE4Qe4=";
          };
          version = "tuwunel-changes";
          patches = [ ];
          postPatch = "";
          cmakeFlags =
            lib.subtractLists [
              # no real reason to have snappy or zlib, no one uses this
              "-DWITH_SNAPPY=1"
              "-DZLIB=1"
              "-DWITH_ZLIB=1"
              # we dont need to use ldb or sst_dump (core_tools)
              "-DWITH_CORE_TOOLS=1"
              # we dont need to build rocksdb tests
              "-DWITH_TESTS=1"
              # we use rust-rocksdb via C interface and dont need C++ RTTI
              "-DUSE_RTTI=1"
              # this doesn't exist in RocksDB, and USE_SSE is deprecated for
              # PORTABLE=$(march)
              "-DFORCE_SSE42=1"
              # PORTABLE will get set in main/default.nix
              "-DPORTABLE=1"
            ] old.cmakeFlags
            ++ [
              # no real reason to have snappy, no one uses this
              "-DWITH_SNAPPY=0"
              "-DZLIB=0"
              "-DWITH_ZLIB=0"
              # we dont need to use ldb or sst_dump (core_tools)
              "-DWITH_CORE_TOOLS=0"
              # we dont need trace tools
              "-DWITH_TRACE_TOOLS=0"
              # we dont need to build rocksdb tests
              "-DWITH_TESTS=0"
              # we use rust-rocksdb via C interface and dont need C++ RTTI
              "-DUSE_RTTI=0"
            ];
          outputs = [ "out" ];
          preInstall = "";
        }
      );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-tuwunel";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "matrix-construct";
    repo = "tuwunel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-41oQfqdsHjm3fBaG+y+Q7eru7LzSIwOc6K5A29Jmt2c=";
  };

  cargoHash = "sha256-bTLKsWsma+a4ZD5ujJJ0xYvk769umIsTNE21KUTJj0U=";

  patches = [
    ./doctest-fix.patch
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
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
  # See https://github.com/matrix-construct/tuwunel/blob/main/src/main/Cargo.toml
  # for available features.
  # We enable all default features except jemalloc, blurhashing, and io_uring, which
  # we guard behind our own (default-enabled) flags.
  buildFeatures = [
    "brotli_compression"
    "direct_tls"
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
    rocksdb = rocksdb'; # make used rocksdb version available (e.g., for backup scripts)
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        inherit (finalAttrs) version;
        package = matrix-tuwunel;
      };
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) matrix-tuwunel;
    };
  };

  meta = {
    description = "Matrix homeserver written in Rust, official successor to conduwuit";
    homepage = "https://github.com/matrix-construct/tuwunel";
    changelog = "https://github.com/matrix-construct/tuwunel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      scvalex
    ];
    mainProgram = "tuwunel";
  };
})
