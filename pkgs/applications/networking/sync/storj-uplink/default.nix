{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.107.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-1VO0kPR9kdterLfLRJrtKfIowppApBCZZaY7yTCncrc=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-CyUthAKwJwocZtvNEy5p/1WmqT4DIl0jN63hiQncrwY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
