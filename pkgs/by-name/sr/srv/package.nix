{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "srv";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "stubbedev";
    repo = "srv";
    rev = "v${version}";
    hash = "sha256-iMoR72iZG4HfGDggyoJzMzo16eiSFKqqLBQF+aZ0m9g=";
  };

  vendorHash = "sha256-wwoPmFZGqFnPfWIDJ9H+g+d79F6FDB3gwFdrQLhlHHk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${src.rev}"
    "-X main.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "CLI tool for managing sites with Traefik reverse proxy";
    homepage = "https://github.com/stubbedev/srv";
    changelog = "https://github.com/stubbedev/srv/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "srv";
    platforms = lib.platforms.unix;
  };
}
