{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.132.7";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-HaI0d4uVPllgW7bRckPrmrYbqNPozqn2rdAg5GDXskg=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-Xl/H7KsCK0bZhZlFO9SkP87PFGkAcAlhBfFs6agguaQ=";

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
