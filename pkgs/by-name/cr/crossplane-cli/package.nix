{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  crossplane-cli,
}:

buildGoModule (finalAttrs: {
  pname = "crossplane-cli";
  version = "1.20.7";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "crossplane";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7U3rITJar0UXXVg1b4m596dVVaZ9j9og725nur+1r4s=";
  };

  vendorHash = "sha256-8k/AFaFOstIOCqRDxDhHF5TI88i0m7CPxqkZFUDr+dE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/crossplane/crossplane/v2/internal/version.version=v${finalAttrs.version}"
  ];

  subPackages = [ "cmd/crank" ];

  postInstall = ''
    mv $out/bin/crank $out/bin/crossplane
  '';

  passthru.tests.version = testers.testVersion {
    package = crossplane-cli;
    command = "crossplane version --client || true";
    version = "v${finalAttrs.version}";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.crossplane.io/";
    changelog = "https://github.com/crossplane/crossplane/releases/tag/v${finalAttrs.version}";
    description = "Utility to make using Crossplane easier";
    mainProgram = "crossplane";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ selfuryon ];
  };
})
