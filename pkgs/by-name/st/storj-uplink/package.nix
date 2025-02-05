{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.121.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-Q/iQUgXeYvGDBuVL8hhHU7SK+sNVQtXCDBoRYFO+N9Y=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-XgHTzE982POxbCzlfSt05y+h8DJb/3fiFV5l/Fu8vGg=";

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
