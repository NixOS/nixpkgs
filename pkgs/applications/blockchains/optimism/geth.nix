{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, libobjc
, IOKit
}:

buildGoModule rec {
  pname = "op-geth";
  version = "1.101200.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-KUq2BSl+9FU7xX0BLWlOEolIgx0VFDXBK6o1YIo9QDQ=";
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

  vendorHash = "sha256-oGMvazo3X9tOmy/o4xUYRlHsQBR0teBj3kF0TlI7mdg=";

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
