{ stdenv, buildGoModule, fetchFromGitHub, libobjc, IOKit }:

buildGoModule rec {
  pname = "go-ethereum";
  version = "1.9.22";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "08i31xil2lygfcn2igsvn4hpg8xnf8l6g914f78hgl4wj6v1dja9";
  };

  runVend = true;
  vendorSha256 = "1qbg44cryiv9kvcak6qjrbmkc9bxyk5fybj62vdkskqfjvv86068";

  doCheck = false;

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
  ];

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  meta = with stdenv.lib; {
    homepage = "https://geth.ethereum.org/";
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = with maintainers; [ adisbladis lionello xrelkd RaghavSood ];
  };
}
