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
  rust-jemalloc-sys-unprefixed,
  enableLiburing ? stdenv.hostPlatform.isLinux,
  liburing,
  nixosTests,
}:
let
  rocksdb' =
    (rocksdb.override {
      inherit enableLiburing;
      # rocksdb does not support prefixed jemalloc, which is required on darwin
      enableJemalloc = enableJemalloc && !stdenv.hostPlatform.isDarwin;
      jemalloc = rust-jemalloc-sys-unprefixed;
    }).overrideAttrs
      (
        final: old: {
          version = "10.4.fb";
          src = fetchFromGitea {
            domain = "forgejo.ellis.link";
            owner = "continuwuation";
            repo = "rocksdb";
            rev = "10.4.fb";
            hash = "sha256-/Hvy1yTH/0D5aa7bc+/uqFugCQq4InTdwlRw88vA5IY=";
          };

          patches = [ ];

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
              "-DPORTABLE=1"
            ];
          outputs = [ "out" ];
          preInstall = "";
          postPatch = ''
            # Fix gcc-13 build failures due to missing <cstdint> and
            # <system_error> includes, fixed upstyream sice 8.x
            sed -e '1i #include <cstdint>' -i db/compaction/compaction_iteration_stats.h
            sed -e '1i #include <cstdint>' -i table/block_based/data_block_hash_index.h
            sed -e '1i #include <cstdint>' -i util/string_util.h
            sed -e '1i #include <cstdint>' -i include/rocksdb/utilities/checkpoint.h
          '';
        }
      );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-continuwuity";
  version = "0.5.0-rc.7";

  # Switch back to fetchFromGitea once archive download errors are fixed
  src = fetchFromGitea {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "continuwuity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u1k1r95qBoEizeILR5rrM5lDFz2a2NjUwM9TTi0HNjw=";
  };

  # Patch to fix linking issue caused by resolv-conf which has been submitted upstream
  # https://github.com/hickory-dns/resolv-conf/pull/55
  cargoPatches = [ ./cargolock.patch ];

  cargoHash = "sha256-ZmDNeIuT49+Mvv8qAahRKe7T73Vh79k5zP1VfjmYdsI=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    zstd
  ]
  ++ lib.optional enableJemalloc [
    rust-jemalloc-sys-unprefixed
  ]
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
    "bindgen-runtime"
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
