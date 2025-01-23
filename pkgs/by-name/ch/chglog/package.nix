{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "chglog";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "chglog";
    tag = "v${version}";
    hash = "sha256-A6PqsyYfhIu3DF1smD5NRLRwISUB806hMQNtDq0G/8Y=";
  };

  vendorHash = "sha256-CbpSlAQLHRyT5Uo9rY/gr+F2jAcqA9M8E8+l3PncdXE=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.builtBy=nixpkgs"
  ];

  meta = {
    description = "Changelog management library and tool";
    homepage = "https://github.com/goreleaser/chglog";
    changelog = "https://github.com/goreleaser/chglog/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ rewine ];
    mainProgram = "chglog";
  };
}
