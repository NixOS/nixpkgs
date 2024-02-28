{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.98.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-XnTrQIDUHdW9HwnYRigGFMGmcSCBhdoTXT4xlMCMeCw=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-n7exLjiDyvnoKAKnJXo1Ag+jh1Ccb2eA3Yv5fg7gkDk=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
