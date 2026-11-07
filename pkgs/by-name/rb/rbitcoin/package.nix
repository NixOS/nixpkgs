{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rbitcoin";
  version = "0.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rbitcoin-org";
    repo = "rbitcoin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xLvGL1W6DQatGvYOQzHyHLSms1iuNFWiQRRr5byfpUQ=";
  };

  cargoHash = "sha256-MCt5EJ1MYOD3JrfMpqXxw60d7Q1Ny2IPX3ZctgEPqPk=";

  # Only the node and the RPC client are products; the remaining workspace
  # members are libraries, test harnesses and benchmarks.
  cargoBuildFlags = [
    "--package"
    "rbitcoin-node"
    "--package"
    "rbitcoin-cli"
  ];

  # The consensus suite reads Bitcoin Core's test vectors from a git submodule
  # it tries to fetch on demand, and the P2P suite depends on wall-clock
  # timeouts. Neither works in the build sandbox.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bitcoin full node in Rust with pure-Rust consensus and a built-in Electrum server";
    homepage = "https://github.com/rbitcoin-org/rbitcoin";
    changelog = "https://github.com/rbitcoin-org/rbitcoin/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ niteshbalusu11 ];
    mainProgram = "rbitcoin-node";
  };
})
