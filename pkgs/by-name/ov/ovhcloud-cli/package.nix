{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "ovhcloud-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "ovhcloud-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZW/o9YpENWmiBYRy+gPQyLM00QM6f+Ym7IFSeArqZ64=";
  };

  vendorHash = "sha256-WNONEceR/cDVloosQ/BMYjPTk9elQ1oTX89lgzENSAI=";

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
