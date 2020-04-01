{ stdenv, buildGoModule, fetchFromGitHub, libobjc, IOKit }:

buildGoModule rec {
  pname = "go-ethereum";
  version = "1.9.11";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xhkdxn5ajzi05252is5whqank81xy94jp1l5z2a44rajv8rh9vs";
  };

  modSha256 = "0jcj0knkhyndndyv1j9xhgbg5psagvyd27ailna3x9ikjlb8f7gg";

  subPackages = [
    "cmd/abigen"
    "cmd/bootnode"
    "cmd/checkpoint-admin"
    "cmd/clef"
    "cmd/devp2p"
    "cmd/ethkey"
    "cmd/evm"
    "cmd/faucet"
    "cmd/geth"
    "cmd/p2psim"
    "cmd/puppeth"
    "cmd/rlpdump"
    "cmd/utils"
    "cmd/wnode"
  ];

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  meta = with stdenv.lib; {
    homepage = "https://geth.ethereum.org/";
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = with maintainers; [ adisbladis asymmetric lionello xrelkd ];
  };
}
