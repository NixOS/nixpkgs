{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sequin";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "sequin";
    rev = "refs/tags/v${version}";
    hash = "sha256-uXfpsrjkJ/qdzoaJXY4vJJPEgcnH7wwFvfHskmEK5VA=";
  };

  vendorHash = "sha256-gdFmvLnf5xW7MKOlRueeoLDTCs7LgMtKiVHS0PAwomc=";

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
