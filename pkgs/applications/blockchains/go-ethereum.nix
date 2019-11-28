{ stdenv, buildGoModule, fetchFromGitHub, libobjc, IOKit }:

buildGoModule rec {
  pname = "go-ethereum";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v4hchy6h3282347ps11iv7klcr60bmghha78rnp0iqpx2k8pqb4";
  };

  modSha256 = "1l10p6a4qq77pfx7jmipkcg2qg6w3hg83q5a37yid3apily2scfa";

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
