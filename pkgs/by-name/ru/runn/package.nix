{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "runn";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "runn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AHdXI/zkhmCRVasTj7Y8WLb+Ju1UUFJstZ0Kgh8L/ng=";
  };

  vendorHash = "sha256-zxyss9Dd4iBnXhZhFlI2k4WK8N0bQb6heskAST2uP28=";

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
