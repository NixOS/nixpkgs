{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.99.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-SzldiGwcpR+UEQ3imJfu3FlYqGq4evsYtjVLybdjGqc=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-mPJVb2/iGbRWDDcfIey3uW/5g2TIIemHR8d/3osMeGA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
