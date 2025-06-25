{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.131.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-9ZBe9m6HD9Cz8afyGqPLnKqrA6OPaxB2azUgr9VP5OY=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-8g5NZpw2T2NuyizSh/cA2seSChEGWzlZmR82Xg0ClKQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
