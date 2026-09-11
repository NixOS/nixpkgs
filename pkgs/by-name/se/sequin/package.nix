{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sequin";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "sequin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rszK2UZ3Eq9g+Di1lncDQIT4TlUcWZEu1SU2aE2uFHY=";
  };

  vendorHash = "sha256-mpmGd6liBzz9XPcB00ZhHaQzTid6lURD5I3EvehXsA8=";

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Human-readable ANSI sequences";
    homepage = "https://github.com/charmbracelet/sequin";
    changelog = "https://github.com/charmbracelet/sequin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caarlos0 ];
    mainProgram = "sequin";
  };
})
