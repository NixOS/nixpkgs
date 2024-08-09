{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.108.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-ZCQRzbu1cNSid/A/NOJm0p/voGP1sXqhxKcSgnu16EI=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-0ukCBIQayJWPWLDFqo23OFTfPJySgD5fftL0b6p0pFY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
