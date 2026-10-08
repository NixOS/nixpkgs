{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libredirect,
  bzip2,
  zstd,
  stdenv,
  rocksdb,
  nix-update-script,
  testers,
  matrix-tuwunel,
  # upstream tuwunel enables jemalloc by default, so we follow suit
  enableJemalloc ? true,
  enableLiburing ? stdenv.hostPlatform.isLinux,
  enableLdap ? true,
  liburing,
  nixosTests,
  writeTextFile,
  rustc-unwrapped,
  cacert,
}:
let
  # tuwunel uses a modified version of rocksdb.  The following overrides take a lot from the
  # official flake:
  # https://github.com/matrix-construct/tuwunel/blob/main/flake.nix#L54
  rocksdb' =
    (rocksdb.override {
      inherit enableLiburing;

      # RocksDB's C++ allocations reach jemalloc by symbol interposition
      # from the unprefixed allocator the Rust build links, so it needs
      # none of its own. A second jemalloc here would serve only the
      # opt-in nodump allocator and malloc-stats, out of a separate heap,
      # and tuwunel uses neither.
      enableJemalloc = false;
    }).overrideAttrs
      (
        final: old: {
          src = fetchFromGitHub {
            owner = "matrix-construct";
            repo = "rocksdb";
            # The commit on the rocksdb fork, tuwunel-changes branch referenced by the upstream
            # tuwunel flake.lock:
            # https://github.com/matrix-construct/tuwunel/blob/main/flake.lock#L557C17-L557C57
            rev = "d8a89161c6a53e79d61694289d2b78be36e6ca12";
            hash = "sha256-rNSA2RalASKbbXNQi86eEmIUC8W5YELKUOy0vhEn6Rc=";
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
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "matrix-construct";
    repo = "tuwunel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MBHChIMNLrP7u8ECRroGiniRGtZGArrpRPfAdkOaOXg=";
  };

  # Integration tests require networking. Only run the unit tests.
  cargoTestFlags = [
    "--lib"
    "--bins"
  ];

  cargoHash = "sha256-NDjFv0iKDfkKwOQ3RZ4gO9eQufGf/dmFaGLTcFWH5uw=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  patches = [
    # reduce closure size by not storing a reference to rustc-unwrapped
    # alternative to https://github.com/NixOS/nixpkgs/pull/462394
    ./dont-record-compilation-flags.patch
  ];

  buildInputs = [
    bzip2
    zstd
  ]
  ++ lib.optional enableLiburing liburing;

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    ROCKSDB_INCLUDE_DIR = "${rocksdb'}/include";
    ROCKSDB_LIB_DIR = "${rocksdb'}/lib";
  };

  buildNoDefaultFeatures = true;
  # See https://github.com/matrix-construct/tuwunel/blob/main/src/main/Cargo.toml
  # for available features.
  # We enable all default features except jemalloc and io_uring, which
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
  ++ lib.optionals enableJemalloc [
    "jemalloc"
    "jemalloc_conf"
  ]
  ++ lib.optional enableLiburing "io_uring"
  ++ lib.optional enableLdap "ldap";

  nativeCheckInputs = [
    libredirect.hook
    cacert
  ];

  # Make sure tuwunel doesn't try to write to arbitrary
  # directories or have DNS timeouts during `cargo test`.
  preCheck =
    let
      fakeResolvConf = writeTextFile {
        name = "resolv.conf";
        text = ''
          nameserver 0.0.0.0
        '';
      };
    in
    ''
      export NIX_REDIRECTS="/etc/resolv.conf=${fakeResolvConf}"
      export TUWUNEL_DATABASE_PATH="$(mktemp -d)/smoketest.db"
    '';

  # The check phase reaches /etc/resolv.conf through libredirect, which works
  # by LD_PRELOAD and is therefore inert in a statically linked binary. A
  # static build would run the tests with no resolver configuration at all and
  # fail before reaching them, so it packages without checking; the unit and
  # integ jobs cover that code on the dynamic path.
  doCheck = !stdenv.hostPlatform.isStatic;

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

  disallowedReferences = [ rustc-unwrapped ];

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
