{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.119.8";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-7SlKUqniRgQfmrBEVnvn7KDa9/QmMmYb7NMrNABGSiU=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-eYFdoc5gtY7u9LFT7EAnooxrOC1y9fIA0ESTP+rPpCc=";

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
