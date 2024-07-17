{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "btcd";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "btcsuite";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-83eiVYXpyiGgLmYxj3rFk4CHG7F9UQ3vk1ZHm64Cm4A=";
  };

  vendorHash = "sha256-ek+gaolwpwoEEWHKYpK2OxCpk/0vywF784J3CC0UCZ4=";

  subPackages = [
    "."
    "cmd/*"
  ];

  preCheck = ''
    DIR="github.com/btcsuite/btcd/"
    # TestCreateDefaultConfigFile requires the sample-btcd.conf in $DIR
    mkdir -p $DIR
    cp sample-btcd.conf $DIR
  '';

  meta = with lib; {
    description = "Alternative full node bitcoin implementation written in Go (golang)";
    homepage = "https://github.com/btcsuite/btcd";
    license = licenses.isc;
    maintainers = with maintainers; [ _0xB10C ];
  };
}
