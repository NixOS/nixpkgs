{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.133.5";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-MvaA8AkoP4FszEEM33QKDt5zeXMZ3XDt5uU1t6C6Q1I=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-N1rEEM+oH2VVOvg9c8gICQ1aDO9FS/faVbQl0kj1jYM=";

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
