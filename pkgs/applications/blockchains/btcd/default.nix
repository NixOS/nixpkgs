{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "btcd";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "btcsuite";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TLnJZW2CkvAqPTnJKfBY41siHtdZ+HRABsc+4vnQ9/w=";
  };

  vendorHash = "sha256-quJEpSDltXhJcgI9H707p3HeLj1uuLzaMplT+YXzh/4=";

  subPackages = [ "." "cmd/*" ];

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
