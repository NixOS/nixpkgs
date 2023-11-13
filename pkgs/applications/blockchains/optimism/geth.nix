{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, libobjc
, IOKit
}:

buildGoModule rec {
  pname = "op-geth";
  version = "1.101304.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-MpLkAAYQmceabVChixF1yqvGSoRm+A9p9mOeKHhqxQE=";
    fetchSubmodules = true;
  };

  subPackages = [
    "cmd/abidump"
    "cmd/abigen"
    "cmd/bootnode"
    "cmd/clef"
    "cmd/devp2p"
    "cmd/ethkey"
    "cmd/evm"
    "cmd/faucet"
    "cmd/geth"
    "cmd/p2psim"
    "cmd/rlpdump"
    "cmd/utils"
  ];

  vendorHash = "sha256-JIuS2qWFf9g5MIJP6jVTSAkPG15XCDeMHcoYeJQz7Og=";

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/ethereum-optimism/op-geth";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
