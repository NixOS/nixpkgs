{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, libobjc
, IOKit
}:

buildGoModule rec {
  pname = "op-geth";
  version = "1.101305.3";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-AKVwwvt77FZlm7089EeayYVRYLo7c3v6LFVpsQN68Zk=";
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

  vendorHash = "sha256-pcIydpKWZt3vwShwzGlPKGq+disdxYFOB8gxHou3mVU=";

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [ libobjc IOKit ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/ethereum-optimism/op-geth";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
