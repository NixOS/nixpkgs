{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  nix-update-script,
  acr-cli,
}:
buildGoModule rec {
  pname = "acr-cli";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "acr-cli";
    tag = "v${version}";
    hash = "sha256-H802VfEy3+bi6VB6z+FyMIFOazHh67mp3/9GuxcU/CU=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Azure/acr-cli/version.Version=${version}"
    "-X=github.com/Azure/acr-cli/version.Revision=${src.rev}"
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
}
