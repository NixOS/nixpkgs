{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sequin";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "sequin";
    tag = "v${version}";
    hash = "sha256-rszK2UZ3Eq9g+Di1lncDQIT4TlUcWZEu1SU2aE2uFHY=";
  };

  vendorHash = "sha256-mpmGd6liBzz9XPcB00ZhHaQzTid6lURD5I3EvehXsA8=";

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = {
    description = "Human-readable ANSI sequences";
    homepage = "https://github.com/charmbracelet/sequin";
    changelog = "https://github.com/charmbracelet/sequin/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caarlos0 ];
    mainProgram = "sequin";
  };
}
