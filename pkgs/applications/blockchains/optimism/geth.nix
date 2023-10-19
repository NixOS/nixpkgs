{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, libobjc
, IOKit
}:

buildGoModule rec {
  pname = "op-geth";
  version = "1.101301.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-3W246cY2l0ZkeaCuDbq/TvKacTKqX7iPs5MMy1+7LxY=";
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

  vendorHash = "sha256-CqmhIz03qrcEetiWjR5A+TCW0ACrxL1UzugcKzTVme0=";

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
