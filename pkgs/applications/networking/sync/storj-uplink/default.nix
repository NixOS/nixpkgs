{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.111.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-WwqB0la3JBJ5074Y0erOIC60++pLLbFF3LhekbRBUWA=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-dA/XMBnFRDBqBlYz3j0Q6E7asmrixG71Vv52F9WX8ew=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
