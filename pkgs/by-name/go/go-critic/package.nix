{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  nix-update-script,
  go-critic,
}:

buildGoModule (finalAttrs: {
  pname = "go-critic";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fR5wWZyBJ0pnKsWkgvFUOqzZ5L+8AgdcGNMbpj+nhyQ=";
  };

  vendorHash = "sha256-o7je2efcEr6nQV+u/zlzVLS1+Pozx2sPCbCZIT5NIIM=";

  subPackages = [
    "cmd/gocritic"
  ];

  allowGoReference = true;

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = go-critic;
      command = "gocritic version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Most opinionated Go source code linter for code audit";
    homepage = "https://go-critic.com/";
    changelog = "https://github.com/go-critic/go-critic/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "gocritic";
    maintainers = with lib.maintainers; [ katexochen ];
  };
})
