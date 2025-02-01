{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nakama";
  version = "3.26.0";

  src = fetchFromGitHub {
    owner = "heroiclabs";
    repo = "nakama";
    tag = "v${version}";
    hash = "sha256-x5gT/mYVaYdeor+U37z1MjJ6zmb7yep/2tVJYgGXPYo=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = {
    description = "Distributed server for social and realtime games and apps";
    homepage = "https://heroiclabs.com/nakama/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.qxrein ];
    mainProgram = "nakama";
  };
}
