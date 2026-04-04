{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "runn";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "runn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fLZNp5QKg+EFE1nykck37gCbLBzJTE+AGdad1bEzLgQ=";
  };

  vendorHash = "sha256-rz7Yc4Cvn100Xgf/yOpvZs4WjoyxNwuS4gPEJ49/gkE=";

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
