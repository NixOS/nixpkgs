{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reth";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "paradigmxyz";
    repo = "reth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zTSwRSSZDINHEkbtTiLP3mgod9lDzFrPxMXq88NTOAM=";
  };

  cargoHash = "sha256-WDe75Sg7y4GfH3dSfY48aXrIBe89skj1VW0NcgtLEVU=";

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
})
