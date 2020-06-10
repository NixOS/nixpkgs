{ stdenv, buildGoModule, fetchFromGitHub, libobjc, IOKit }:

buildGoModule rec {
  pname = "go-ethereum";
  version = "1.9.15";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c69rfnx9130b87pw9lnaxyrbzwfhqb2dxyl7qyiscq85hqs16f9";
  };

  usb = fetchFromGitHub {
    owner = "karalabe";
    repo = "usb";
    rev = "911d15fe12a9c411cf5d0dd5635231c759399bed";
    sha256 = "0asd5fz2rhzkjmd8wjgmla5qmqyz4jaa6qf0n2ycia16jsck6wc2";
  };

  vendorSha256 = "1pjgcx6sydfipsx8s0kl7n6r3lk61klsfrkd7cg4l934k590q2n7";

  overrideModAttrs = (_: {
      postBuild = ''
      cp -r --reflink=auto ${usb}/libusb vendor/github.com/karalabe/usb
      cp -r --reflink=auto ${usb}/hidapi vendor/github.com/karalabe/usb
      '';
    });

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
