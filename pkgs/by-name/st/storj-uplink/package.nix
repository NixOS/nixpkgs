{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.131.7";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-zZQOiYH2YN6pRwu2ddt+IEJ35RJ3rplbQ+T4/zKtv8w=";
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
