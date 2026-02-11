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
  rust-jemalloc-sys-unprefixed,
  liburing,
  nixosTests,
}:
let
  rocksdb' =
    (rocksdb.override {
      # rocksdb does not support prefixed jemalloc, which is required on darwin
      enableJemalloc = !stdenv.hostPlatform.isDarwin;
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
  version = "0.5.4";

  src = fetchFromGitea {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "continuwuity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E2BJh0ynzUm3gHJXM0qKIgTyEEMD02PG+uPPdr/MKaQ=";
  };

  cargoHash = "sha256-yPQxEZwMQv7HqlQzQxwGrUzZOL21cfNymkNdkOA4GIk=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    zstd
    rust-jemalloc-sys-unprefixed
    liburing
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    ROCKSDB_INCLUDE_DIR = "${rocksdb'}/include";
    ROCKSDB_LIB_DIR = "${rocksdb'}/lib";
  };

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
