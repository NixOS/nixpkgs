{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.114.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-V7Vl2sViRl6olhCdJF4xtR7iyJCqJCrm39/Aq1T9GFQ=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-+eqT3VNqw3fOLwfCKPacIEcoXjuzPaY1EAZI95rgLDs=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
