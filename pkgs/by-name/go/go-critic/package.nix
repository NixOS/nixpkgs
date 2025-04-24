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
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${version}";
    hash = "sha256-KH7jawMd73qdl1S+YQlQGW/2Vj8XjMLJ15Hz0cdwDO4=";
  };

  vendorHash = "sha256-vBGCFnKKpMcM7RWmT05oPwCItR4QMHhTAZ8x2ejJpcI=";

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
