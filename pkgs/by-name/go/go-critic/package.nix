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
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+PYIZBjq3kHaTXoZInfqT0EJDeil2+kyTxgKY2sKTs0=";
  };

  vendorHash = "sha256-2tzBJI2d9/EY1lPgJDrOGfgh8dz2bYwP5kWifJ46a8I=";

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
