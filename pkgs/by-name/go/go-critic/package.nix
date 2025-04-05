{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  nix-update-script,
  go-critic,
}:

buildGoModule rec {
  pname = "go-critic";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${version}";
    hash = "sha256-0AOhq7OhSHub4I6XXL018hg6i2ERkIbZCrO9osNjvHw=";
  };

  vendorHash = "sha256-yTm5Hhqbk1aJ4ZAR+ie2NnDOAGpjijUKQxZW3Tp9bs8=";

  subPackages = [
    "cmd/gocritic"
  ];

  allowGoReference = true;

  ldflags = [
    "-X main.Version=${version}"
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
    changelog = "https://github.com/go-critic/go-critic/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    mainProgram = "gocritic";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
