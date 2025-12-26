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
          version = "10.5.1";
          src = fetchFromGitea {
            domain = "forgejo.ellis.link";
            owner = "continuwuation";
            repo = "rocksdb";
            rev = "10.5.fb";
            hash = "sha256-X4ApGLkHF9ceBtBg77dimEpu720I79ffLoyPa8JMHaU=";
          };

          patches = [ ];

          cmakeFlags =
            lib.subtractLists [
              # no real reason to have snappy or zlib, no one uses this
              (lib.cmakeBool "WITH_SNAPPY" true)
              (lib.cmakeBool "ZLIB" true)
              (lib.cmakeBool "WITH_ZLIB" true)
              # we dont need to use ldb or sst_dump (core_tools)
              (lib.cmakeBool "WITH_CORE_TOOLS" true)
              # we dont need to build rocksdb tests
              (lib.cmakeBool "WITH_TESTS" true)
              # we use rust-rocksdb via C interface and dont need C++ RTTI
              (lib.cmakeBool "USE_RTTI" true)
              # this doesn't exist in RocksDB
              (lib.cmakeBool "FORCE_SSE43" true)
            ] old.cmakeFlags
            ++ [
              # no real reason to have snappy, no one uses this
              (lib.cmakeBool "WITH_SNAPPY" false)
              (lib.cmakeBool "ZLIB" false)
              (lib.cmakeBool "WITH_ZLIB" false)
              # we dont need to use ldb or sst_dump (core_tools)
              (lib.cmakeBool "WITH_CORE_TOOLS" false)
              # we dont need to build rocksdb tests
              (lib.cmakeBool "WITH_TESTS" false)
              # we use rust-rocksdb via C interface and dont need C++ RTTI
              (lib.cmakeBool "USE_RTTI" false)
              (lib.cmakeBool "WITH_TRACE_TOOLS" false)
            ];
          outputs = [ "out" ];

          # We aren't building tools, the original package uses this to make sure rocksdb
          # tools work as expected. Hence we override this and make it empty.
          preInstall = "";
        }
      );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-continuwuity";
  version = "0.5.0";

  src = fetchFromGitea {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "continuwuity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k+B7OjOoVd/vcy/jKBEXAXOolnWt4RoPhJucMwYxyEk=";
  };

  cargoHash = "sha256-xqP2wOaGJEcn/ZF8u1Ol6j7zyr/3dLHKU6eYQfIBr7o=";

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
    "ldap"
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
