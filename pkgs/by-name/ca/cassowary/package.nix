{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cassowary";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "rogerwelin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lC3GOS4hugRoQbJYVGv6kl3h6xMAukcOdV2m/u3Wgkk=";
  };

  vendorHash = "sha256-YP9q9lL2A9ERhzbJBIFKsYsgvy5xYeUO3ekyQdh97f8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    homepage = "https://github.com/rogerwelin/cassowary";
    description = "Modern cross-platform HTTP load-testing tool written in Go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hugoreeves ];
    mainProgram = "cassowary";
  };
}
