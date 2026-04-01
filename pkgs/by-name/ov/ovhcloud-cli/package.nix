{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

buildGo126Module (finalAttrs: {
  pname = "ovhcloud-cli";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "ovhcloud-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NBfMxXu5sZpv+OnoMCq4xc4AVQU+mbPrapVdq2Hffb8=";
  };

  vendorHash = "sha256-JNnIpRr4zdGtlOOKGf1bQVViMgjnwGBAmYbFcCpzStY=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ovh/ovhcloud-cli/internal/version.Version=${finalAttrs.version}"
  ];

  excludedPackages = [ "cmd/docgen" ];

  nativeBuildInputs = [ installShellFiles ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "ovhcloud version";
  };

  meta = {
    homepage = "https://github.com/ovh/ovhcloud-cli";
    changelog = "https://github.com/ovh/ovhcloud-cli/releases/tag/v${finalAttrs.version}";
    description = "Command Line Interface to manage your OVHcloud services";
    mainProgram = "ovhcloud";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
})
