{ lib
, buildGoModule
, fetchFromGitHub
, testers
, nix-update-script
, go-critic
}:

buildGoModule rec {
  pname = "go-critic";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${version}";
    hash = "sha256-jL/z1GtHmEbS8vsIYG1jEZOxySXqU92WIq9p+GDTP8E=";
  };

  vendorHash = "sha256-qQO4JWMU8jfc64CBPaMRYRbUsgLQZx9P5AKbSPyHnRE=";

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
