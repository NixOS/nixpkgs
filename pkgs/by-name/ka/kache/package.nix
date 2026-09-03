{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kache";
  version = "0.15.1";
  __structuredAttrs = true;
  doCheck = true;

  src = fetchFromGitHub {
    owner = "kunobi-ninja";
    repo = "kache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-foSH+N/EhZFbEPD1yFbZDzxv+B2Q7IVEJA0Q4BPsRVQ=";
  };

  cargoHash = "sha256-BnwKnStmG+pqeE06BbD1VwrNFGKd+dX8GhFez5F+1Kc=";

  # cargo-auditable takes over the RUSTC_WRAPPER slot to collect the
  # dependency tree, which prevents kache from being invoked as its own
  # rustc-wrapper in the integration tests.
  auditable = false;

  postPatch = ''
    # Cargo exports CARGO_BUILD_TARGET to test binaries. The integration
    # tests build a native bootstrap binary themselves, so remove the
    # package target from that child Cargo invocation.
      substituteInPlace tests/common/mod.rs \
        --replace-fail \
          '.env_remove("CARGO_BUILD_RUSTC_WRAPPER")' \
          '.env_remove("CARGO_BUILD_RUSTC_WRAPPER")
        .env_remove("CARGO_BUILD_TARGET")'
      substituteInPlace tests/custom_harness_test.rs \
        --replace-fail \
          '.env("CARGO_INCREMENTAL", "0")' \
          '.env("CARGO_INCREMENTAL", "0")
        .env_remove("CARGO_BUILD_TARGET")'
  '';

  # reqwest (rustls) loads system CA certificates while building a client
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  checkFlags = [
    "--skip=test_exclude_from_indexing_sets_tmutil_xattr" # requires tmutil (Time Machine)
    "--skip=test_wrapper_hello_world" # assumes a host-native Cargo target directory layout
  ];

  meta = {
    description = "Zero-copy, content-addressed build cache for Rust, C/C++ and more, with S3 and shared-filesystem remotes";
    longDescription = ''
      Kache is a build cache system that acts as a RUSTC_WRAPPER for Rust and a compiler wrapper for C/C++.
      It eliminates redundant compilation work through intelligent caching using content-addressed storage.
      Supports S3, shared filesystem, and local storage backends.
    '';
    homepage = "https://kunobi.ninja/docs/kache";
    changelog = "https://github.com/kunobi-ninja/kache/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "kache";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
  };
})
