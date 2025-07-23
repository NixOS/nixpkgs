{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "katana";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${version}";
    hash = "sha256-AErn0m4OLnMX+zAuoYm71AqXnJfQjsSt+KqWUP93/ws=";
  };

  vendorHash = "sha256-st7gj4hynuY1dDUEhA4xbiOnxH3jV5T2RK+PhB46Lpk=";

  subPackages = [ "cmd/katana" ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "katana";
  };
}
