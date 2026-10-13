{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

let
  # Place geth in a separate output from the other utilities in subPackages, to reduce closure size of the module.
  bins = [ "geth" ];

in
buildGoModule (finalAttrs: {
  pname = "go-ethereum";
  version = "1.17.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FaVO1p7eZsXQN1Ikq2CcgiugHkSyETGagZLw6hIF7to=";
  };

  proxyVendor = true;
  vendorHash = "sha256-AsKicppcvr7xZ2sZ1pvsu8inXBRM1W3lFMlWAvV/EL0=";

  doCheck = false;

  outputs = [ "out" ] ++ bins;

  # Move binaries to separate outputs and symlink them back to $out
  postInstall = lib.concatStringsSep "\n" (
    map (
      bin:
      "mkdir -p \$${bin}/bin && mv $out/bin/${bin} \$${bin}/bin/ && ln -s \$${bin}/bin/${bin} $out/bin/"
    ) bins
  );

  subPackages = [
    "cmd/abidump"
    "cmd/abigen"
    "cmd/blsync"
    "cmd/devp2p"
    "cmd/era"
    "cmd/ethkey"
    "cmd/evm"
    "cmd/geth"
    "cmd/rlpdump"
    "cmd/utils"
  ];

  # Following upstream: https://github.com/ethereum/go-ethereum/blob/v1.11.6/build/ci.go#L218
  tags = [ "urfave_cli_no_docs" ];

  passthru.tests = { inherit (nixosTests) geth; };

  meta = {
    homepage = "https://geth.ethereum.org/";
    description = "Official golang implementation of the Ethereum protocol";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    maintainers = with lib.maintainers; [
      asymmetric
      RaghavSood
    ];
    mainProgram = "geth";
  };
})
