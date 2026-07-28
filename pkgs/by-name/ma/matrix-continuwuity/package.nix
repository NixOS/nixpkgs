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
          version = "11.1.1";
          src = fetchFromGitea {
            domain = "forgejo.ellis.link";
            owner = "continuwuation";
            repo = "rocksdb";
            rev = "3756b2b905e13216d8b56bcc783d814e7b073aff";
            hash = "sha256-rSv4fr2bf9JJwdodgeuPCuceeh7k97KVxrAOC0wyPQY=";
          };

          patches = [ ];
        }
      );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-continuwuity";
  version = "26.7.1";

  src = fetchFromGitea {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "continuwuity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gdTj7y1fwTG0CNWeK/0An6WM8YEeiw7TOuTjh1Zbe50=";
  };

  cargoHash = "sha256-nhL4GRmw49n+UlHUKHcEJPoT/BNm+6eatqz/m+zjahg=";

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
      bartoostveen
      nyabinary
      snaki
    ];
    # Not a typo, continuwuity is a drop-in replacement for conduwuit.
    mainProgram = "conduwuit";
  };
})
