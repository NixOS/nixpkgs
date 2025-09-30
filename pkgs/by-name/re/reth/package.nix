{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "reth";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "paradigmxyz";
    repo = "reth";
    rev = "v${version}";
    hash = "sha256-Th2ibG4fVQPPxRSS4ChOQ176xUq3eU1/zNQbQlJUFNw=";
  };

  cargoHash = "sha256-2zdilVIHCW0N2yZNfLNoVpTASjXU1ABcZzQLzpAGEsY=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  # Some tests fail due to I/O that is unfriendly with nix sandbox.
  checkFlags = [
    "--skip=builder::tests::block_number_node_config_test"
    "--skip=builder::tests::launch_multiple_nodes"
    "--skip=builder::tests::rpc_handles_none_without_http"
    "--skip=cli::tests::override_trusted_setup_file"
    "--skip=cli::tests::parse_env_filter_directives"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modular Ethereum execution client in Rust by Paradigm";
    homepage = "https://github.com/paradigmxyz/reth";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "reth";
    maintainers = with lib.maintainers; [ mitchmindtree ];
    platforms = lib.platforms.unix;
  };
}
