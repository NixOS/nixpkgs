{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cloudfoundry-cli-plugin-multiapps";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "multiapps-cli-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yKDFootkizkUexi644ubEsLm+f5ps/VRFTimhVnKhv8=";
  };

  vendorHash = "sha256-MKAEmW3ox5T6L88dc41FAfLZRKp6EQnbfd7YWAy7KGY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Cloud Foundry CLI plugin for deploying and managing multi-target applications (MTA)";
    homepage = "https://github.com/cloudfoundry/multiapps-cli-plugin";
    changelog = "https://github.com/cloudfoundry/multiapps-cli-plugin/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vo1dsh4d0w ];
    mainProgram = "multiapps-cli-plugin";
  };
})
