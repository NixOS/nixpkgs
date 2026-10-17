{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  fetchFromGitHub,
  cacert,
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
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HLISCnfYM07jJ1jfER6i+zMlzYxWq+DJ2FVgpjkTytg=";
  };

  cargoHash = "sha256-QG4HMADZmOu5ilFZBqogdrwBaBegoqNP9GvsDddUYbs=";

  patches = lib.optionals (stdenv.hostPlatform.isx86_64 && lib.versionOlder rustc.llvm.version "22") [
    # Remove when https://github.com/NixOS/nixpkgs/pull/544495 is merged and propagated to master
    ./0001-disable-avx512vnni.patch
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

  nativeCheckInputs = [ cacert ];

  checkFlags = [
    # This test assumes the process starts without any existing children,
    # which is not reliable in the Nix build sandbox.
    "--skip=common::metrics::procfs_metrics::test_child_processes"
  ];

  # Fix cargo-auditable issue with bench_rocksdb = ["dep:rocksdb"]
  auditable = false;

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
    maintainers = with lib.maintainers; [
      miniharinn
    ];
  };
})
