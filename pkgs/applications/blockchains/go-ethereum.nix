{ stdenv, buildGoModule, fetchFromGitHub, libobjc, IOKit }:

buildGoModule rec {
  pname = "go-ethereum";
  version = "1.9.17";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "175cy5cqkdhvh3kv2d0madybbz2sdbgxhm8xfb3ydbaf2hzihxmx";
  };

  modvendorCopy = true;
  vendorSha256 = "0iwcdv6wvjbp84m5d2l3996wpklzik1dx4n70v2kd9fcsqcrgvvq";

  subPackages = [
    "cmd/abidump"
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
    maintainers = with maintainers; [ adisbladis lionello xrelkd ];
  };
}
