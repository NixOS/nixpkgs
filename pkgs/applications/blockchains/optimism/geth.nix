{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, libobjc
, IOKit
}:

buildGoModule rec {
  pname = "op-geth";
  version = "1.101200.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-xF/KaN/O0Hn3W2a11ivdgLVr5gR14dW5807r1snQ9xw=";
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

  vendorHash = "sha256-5G0wPQaP2MofQQO1AiFa1BF8zarRnYyNYscbZ4Ku44o=";

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
