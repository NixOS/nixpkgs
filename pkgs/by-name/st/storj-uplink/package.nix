{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.120.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-Ze3eQCySw3S6sKXwJCW6M+UV1FWp47syCWxIQdKttOs=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-kLXrKFJ/g2xenYTZ13loaZ7XAgRhmo2Iwen7P4esBIs=";

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
