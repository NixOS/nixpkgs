{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.100.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-wc6oK1zn04/1nwis9ndpkQc8dwY/J85zZbhkwmNFLek=";
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
