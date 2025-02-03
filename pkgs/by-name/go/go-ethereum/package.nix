{ lib, stdenv, buildGoModule, fetchFromGitHub, libobjc, IOKit, nixosTests }:

let
  # A list of binaries to put into separate outputs
  bins = [
    "geth"
    "clef"
  ];

in buildGoModule rec {
  pname = "go-ethereum";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-X9XwVZpRnkp7oVKwyvQbs8ZaWwLkuLEEHNfV5BvfVvI=";
  };

  proxyVendor = true;
  vendorHash = "sha256-UP+bQM8ydfbILlVhuNPVIKLyXZFTzGmHizn2hYgNE4Y=";

  doCheck = false;

  outputs = [ "out" ] ++ bins;

  # Move binaries to separate outputs and symlink them back to $out
  postInstall = lib.concatStringsSep "\n" (
    builtins.map (bin: "mkdir -p \$${bin}/bin && mv $out/bin/${bin} \$${bin}/bin/ && ln -s \$${bin}/bin/${bin} $out/bin/") bins
  );

  subPackages = [
    "cmd/abidump"
    "cmd/abigen"
    "cmd/blsync"
    "cmd/bootnode"
    "cmd/clef"
    "cmd/devp2p"
    "cmd/era"
    "cmd/ethkey"
    "cmd/evm"
    "cmd/geth"
    "cmd/p2psim"
    "cmd/rlpdump"
    "cmd/utils"
  ];

  # Following upstream: https://github.com/ethereum/go-ethereum/blob/v1.11.6/build/ci.go#L218
  tags = [ "urfave_cli_no_docs" ];

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  passthru.tests = { inherit (nixosTests) geth; };

  meta = with lib; {
    homepage = "https://geth.ethereum.org/";
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3Plus gpl3Plus ];
    maintainers = with maintainers; [ RaghavSood ];
    mainProgram = "geth";
  };
}
