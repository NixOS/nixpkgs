{ lib
, buildGoModule
, fetchFromGitHub
, testers
, nix-update-script
, go-critic
}:

buildGoModule rec {
  pname = "go-critic";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${version}";
    hash = "sha256-xej9ROsJYrjvlitxnAjUKPsp0kb8INvFnkdNfYiycz8=";
  };

  vendorHash = "sha256-pYdnZjCGx+skF/kqA1QO3NuVqOfsMJNVhFBpwtdZhIA=";

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
