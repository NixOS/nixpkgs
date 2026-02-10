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
  version = "0.17";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "acr-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mS6IgeQqjdruSlsr2cssdbsTOWM4STBqp/RtrWXG9/c=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Azure/acr-cli/version.Version=${finalAttrs.version}"
    "-X=github.com/Azure/acr-cli/version.Revision=${finalAttrs.src.rev}"
  ];

  executable = [ "acr" ];

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
