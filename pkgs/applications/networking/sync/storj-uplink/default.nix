{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.89.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-tbzdfKA3ojwTvJ+t7jLLy3iKQ/x/0lXDcb2w1XcyEhs=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-AME5EM2j7PQ/DodK+3BiVepTRbwMqqItQbmCJ2lrGM8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
