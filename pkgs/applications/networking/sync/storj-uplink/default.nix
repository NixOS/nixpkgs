{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.100.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-/aR6M/zL7xL+ujmGgu9J8Toiy7/0ou76nYJ0vwd5RVM=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-84PI1tZFiodnGvMwObELVxXMCgIWINOrO0ISAWRnxRM=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
