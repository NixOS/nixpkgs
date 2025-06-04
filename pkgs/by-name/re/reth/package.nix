{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "reth";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "paradigmxyz";
    repo = "reth";
    rev = "v${version}";
    hash = "sha256-PEqkZS2zH7m5qkmv6mWTq1tWcNfzalr/EzZtXszDHSU=";
  };

  cargoHash = "sha256-fWohViQ/FC4/meVt9FRuPe3MlEFrAczW5cOsXW3KtRk=";

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
