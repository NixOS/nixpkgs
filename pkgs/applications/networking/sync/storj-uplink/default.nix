{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.87.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-16h7PzZVFnaHMyODLk9tSrW8OiXQlcuDobANG1ZQVxs=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-gskOhLdrRzbvZwuOlm04fjeSXhNr/cqVGejEPZVtuBk=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
