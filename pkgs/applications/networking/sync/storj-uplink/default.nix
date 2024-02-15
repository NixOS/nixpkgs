{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.96.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-mQIrXDEfMMrubQyn90eu0k3isvnpaF237Tpd84HhUfU=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-cUhdl0jqgkA89NeOdFSifR5LsTjeYifOXqBu3qCAovk=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
