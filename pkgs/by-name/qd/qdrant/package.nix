{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  protobuf,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
  rust-jemalloc-sys-unprefixed,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qdrant";
  version = "1.15.5";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/bwSkXfk/7wyWhAE87SY99EOcHmzBwXzX5PNBdKOJUQ=";
  };

  cargoHash = "sha256-U5CPqwsYW6QCGg2mFKzX50imnrvfGNSuFtYkwAB1OE4=";

  patches = [
    (fetchpatch {
      name = "CVE-2026-25628.patch";
      url = "https://github.com/qdrant/qdrant/commit/32b7fdfb7f542624ecd1f7c8d3e2b13c4e36a2c1.patch";
      hash = "sha256-dXbWWRzODpUU3PhTD8935KH9G2I+sw/l/hKGECN5yVw=";
    })
  ];

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    openssl
    rust-jemalloc-sys
    rust-jemalloc-sys-unprefixed
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  # Fix cargo-auditable issue with bench_rocksdb = ["dep:rocksdb"]
  auditable = false;

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector Search Engine for the next generation of AI applications";
    longDescription = ''
      Expects a config file at config/config.yaml with content similar to
      https://github.com/qdrant/qdrant/blob/master/config/config.yaml
    '';
    homepage = "https://github.com/qdrant/qdrant";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
