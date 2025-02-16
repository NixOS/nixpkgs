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
    hash = "sha256-so8N2gk4TfeJy30XxiXH7utXs8InvnXm68ZoSvFykQk=";
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
    changelog = "https://github.com/heroiclabs/nakama/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.qxrein ];
    mainProgram = "nakama";
  };
}
