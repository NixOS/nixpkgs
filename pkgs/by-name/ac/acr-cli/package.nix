{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  nix-update-script,
  acr-cli,
}:
buildGoModule (finalAttrs: {
  pname = "acr-cli";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "acr-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vNfQit4gwtV+14vXJX/18PXp2kFPi4ZWcuWym/R1qSE=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Azure/acr-cli/version.Version=${finalAttrs.version}"
    "-X=github.com/Azure/acr-cli/version.Revision=${finalAttrs.src.rev}"
  ];

  executable = [ "acr" ];

  # Required for some tests on darwin.
  __darwinAllowLocalNetworking = true;

  # Test checks for legacy error which has been changed in newer go versions.
  checkFlags = [ "-skip=^TestParseDuration" ];

  passthru.tests.version = testers.testVersion {
    package = acr-cli;
    command = "acr version";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command Line Tool for interacting with Azure Container Registry Images";
    homepage = "https://github.com/Azure/acr-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hausken ];
    mainProgram = "acr-cli";
  };
})
