{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "rbitcoin";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "rbitcoin-org";
    repo = "rbitcoin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xLvGL1W6DQatGvYOQzHyHLSms1iuNFWiQRRr5byfpUQ=";
  };

  cargoHash = "sha256-MCt5EJ1MYOD3JrfMpqXxw60d7Q1Ny2IPX3ZctgEPqPk=";

  cargoBuildFlags = [
    "-p"
    "rbitcoin-node"
    "-p"
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
    description = "Bitcoin full node and command-line client written in Rust";
    homepage = "https://github.com/rbitcoin-org/rbitcoin";
    changelog = "https://github.com/rbitcoin-org/rbitcoin/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      niteshbalusu11
      prusnak
    ];
    mainProgram = "rbitcoin-node";
  };
})
