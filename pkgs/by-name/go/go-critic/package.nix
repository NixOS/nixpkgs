{ lib
, buildGoModule
, fetchFromGitHub
, testers
, nix-update-script
, go-critic
}:

buildGoModule rec {
  pname = "go-critic";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${version}";
    hash = "sha256-8dRgPhYedEPwK4puP8hJWhjub2NkOl3OWNRb43AH3xc=";
  };

  vendorHash = "sha256-0Y9yMcgyRgXQUie7oj0bRy4+eGfQOa9QXux2AoRc6pw=";

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
    description = "The most opinionated Go source code linter for code audit";
    homepage = "https://go-critic.com/";
    changelog = "https://github.com/go-critic/go-critic/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    mainProgram = "gocritic";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
