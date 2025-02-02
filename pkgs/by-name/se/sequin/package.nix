{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sequin";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "sequin";
    rev = "refs/tags/v${version}";
    hash = "sha256-pGZ7QmmPIpXrRcfkbEbTZzHXHtqPwU8Cju9Q2xtSqvw=";
  };

  vendorHash = "sha256-LehOqSahbF3Nqm0/bJ0Q3mR0ds8FEXaLEvGLwzPdvU4=";

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
