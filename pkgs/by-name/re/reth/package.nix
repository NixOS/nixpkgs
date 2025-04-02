{ lib
, stdenv
, darwin
, fetchFromGitHub
, nix-update-script
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "reth";
  version = "0.1.0-alpha.16";

  src = fetchFromGitHub {
    owner = "paradigmxyz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5iYGNj+IC63lhgVPZf4U0yOWFDDH+x+a5M5eFpnfQYU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alloy-genesis-0.1.0" = "sha256-JwUtwx9WK/CcMDHcahc65f1thsLg5/Tnifjwipv/bmE=";
      "discv5-0.3.1" = "sha256-Z/Yl/K6UKmXQ4e0anAJZffV9PmWdBg/ROnNBrB8dABE=";
      "igd-0.12.0" = "sha256-wjk/VIddbuoNFljasH5zsHa2JWiOuSW4VlcUS+ed5YY=";
      "revm-3.5.0" = "sha256-mI+tecvC9BHXl4+ju4VfYUD3mKO+jp0/KC9KjiyzD+Q=";
      "revm-inspectors-0.1.0" = "sha256-yBqeANijUCBRhOU7XjQvo4H8dbFPFFKErzmZ+Lw4OSA=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # Some tests fail due to I/O that is unfriendly with nix sandbox.
  checkFlags = [
    "--skip=builder::tests::block_number_node_config_test"
    "--skip=builder::tests::launch_multiple_nodes"
    "--skip=builder::tests::rpc_handles_none_without_http"
    "--skip=cli::tests::override_trusted_setup_file"
    "--skip=cli::tests::parse_env_filter_directives"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version" "unstable" ];
  };

  meta = with lib; {
    description = "A modular Ethereum execution client in Rust by Paradigm";
    homepage = "https://github.com/paradigmxyz/reth";
    license = with licenses; [ mit asl20 ];
    mainProgram = "reth";
    maintainers = with maintainers; [ mitchmindtree ];
    platforms = lib.platforms.unix;
  };
}
