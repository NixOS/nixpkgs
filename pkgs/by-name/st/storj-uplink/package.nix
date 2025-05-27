{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.129.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-yjCLVNnVdfsallt1dmePcL9Iwvc+tpFIW3Uvfy0N1YM=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-CTcFTEKj5s43OlrIC7lOh3Lh/6k8/Igckv0zwrdGKbE=";

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
