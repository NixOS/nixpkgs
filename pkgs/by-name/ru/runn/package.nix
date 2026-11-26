{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "runn";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "runn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qk+b/sqn+r/DiPr+cjjJvbaJz3PN+NE4Ehn2JFD+v5s=";
  };

  vendorHash = "sha256-qw2/7OEW5eq8oSeH9g067OxzG2YdgD9XnlYU0Ah2iU0=";

  subPackages = [ "cmd/runn" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/runn/version.Version=${finalAttrs.version}"
  ];

  # Tests require external services (PostgreSQL, MySQL, Chrome, gRPC)
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scenario-based testing tool for APIs, databases, and more";
    homepage = "https://github.com/k1LoW/runn";
    changelog = "https://github.com/k1LoW/runn/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    mainProgram = "runn";
  };
})
