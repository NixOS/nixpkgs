{ lib
, buildGoModule
, fetchFromGitHub
, testers
, nix-update-script
, go-critic
}:

buildGoModule rec {
  pname = "go-critic";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${version}";
    hash = "sha256-GEwUz6iH9y+d2UoKY68VHOKomn4EUkzoUgNHTqluW8I=";
  };

  vendorHash = "sha256-rfqX76SQnLQFwheHlS3GZD+jeaVd38qfSnQCH7OH6+I=";

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
