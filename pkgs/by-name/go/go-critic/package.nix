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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${version}";
    hash = "sha256-iGJ2GPag79HSdwCJOuUn86fEe1/NhmPXVRCCYeWokGw=";
  };

  vendorHash = "sha256-DhjXu/9Cv/pcBuC83Hc2PpgvN9k445WOr1IBkxtmQlw=";

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
