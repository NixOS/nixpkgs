{
  lib,
  aws-lc,
  fetchFromGitHub,
  gnum4,
  libgit2,
  libxml2,
  llvmPackages_23,
  nix-update-script,
  perl,
  pkg-config,
  rust-jemalloc-sys,
  rustPlatform,
  writableTmpDirAsHomeHook,
  zlib,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reth";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "paradigmxyz";
    repo = "reth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HA041qzWEN+KfsAyc2vcpcuV5aVWBKoCqMfg9FjtKGk=";
  };

  cargoHash = "sha256-jLupFbptiNn9KpGj+fZSRBzwuUeVSMCxj0wpB5XyKng=";

  nativeBuildInputs = [
    gnum4
    llvmPackages_23.clang
    perl
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    aws-lc
    libgit2
    libxml2
    llvmPackages_23.llvm
    rust-jemalloc-sys
    zlib
    zstd
  ];

  env = {
    LLVM_SYS_231_PREFIX = "${llvmPackages_23.llvm.dev}";

    # The source archive does not contain Git metadata.
    VERGEN_GIT_SHA = "0000000000000000000000000000000000000000";
    VERGEN_GIT_DESCRIBE = "v${finalAttrs.version}";
    VERGEN_GIT_DIRTY = "false";
  };

  # The integration tests start local RPC and snapshot servers.
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # Some tests fail due to I/O that is unfriendly with nix sandbox.
  checkFlags = [
    "--skip=builder::tests::block_number_node_config_test"
    "--skip=builder::tests::launch_multiple_nodes"
    "--skip=builder::tests::rpc_handles_none_without_http"
    "--skip=cli::tests::override_trusted_setup_file"
    "--skip=cli::tests::parse_env_filter_directives"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$" ];
  };

  meta = {
    description = "Modular Ethereum execution client in Rust by Paradigm";
    homepage = "https://github.com/paradigmxyz/reth";
    changelog = "https://github.com/paradigmxyz/reth/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "reth";
    maintainers = with lib.maintainers; [ mitchmindtree ];
    platforms = lib.platforms.unix;
  };
})
