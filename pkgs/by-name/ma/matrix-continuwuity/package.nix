{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  bzip2,
  zstd,
  stdenv,
  callPackage,
  nix-update-script,
  testers,
  matrix-continuwuity,
  rust-jemalloc-sys-unprefixed,
  liburing,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-continuwuity";
  version = "26.7.2";

  src = fetchFromGitea {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "continuwuity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uE38tYYgze2q4hgW1mzk5CLTD3ezAwCnj+RQOmZtCdw=";
  };

  cargoHash = "sha256-DZsRr0Xt/7HnlNCZfXK4dUILK/uEOnSD+r26OxvycD0=";

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
    ROCKSDB_INCLUDE_DIR = "${finalAttrs.rocksdb}/include";
    ROCKSDB_LIB_DIR = "${finalAttrs.rocksdb}/lib";
  };

  rocksdb = callPackage ./rocksdb.nix { }; # make used rocksdb version available (e.g., for backup scripts)

  passthru = {
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
      bartoostveen
      nyabinary
      snaki
    ];
    # Not a typo, continuwuity is a drop-in replacement for conduwuit.
    mainProgram = "conduwuit";
  };
})
