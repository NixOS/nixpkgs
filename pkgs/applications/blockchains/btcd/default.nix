{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "btcd";
  version = "0.23.4";

  src = fetchFromGitHub {
    owner = "btcsuite";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-X1kfr6jrVArm0HK0XiN/93OPxqPo8J4U+qglJAf23+A=";
  };

  vendorHash = "sha256-3w8rb0sfAIFCXqPXOKb4QwoLd7WsbFv3phu/rJCEjeY=";

  subPackages = [ "." "cmd/*" ];

  preCheck = ''
    DIR="github.com/btcsuite/btcd/"
    # TestCreateDefaultConfigFile requires the sample-btcd.conf in $DIR
    mkdir -p $DIR
    cp sample-btcd.conf $DIR
  '';

  meta = with lib; {
    description = "An alternative full node bitcoin implementation written in Go (golang)";
    homepage = "https://github.com/btcsuite/btcd";
    license = licenses.isc;
    maintainers = with maintainers; [ _0xB10C ];
  };
}
