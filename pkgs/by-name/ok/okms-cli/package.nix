{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "okms-cli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "okms-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XW+otYeEQAuPVOXI6unTi28vn6dvpO7aVkr2bZ039Mk=";
  };

  vendorHash = "sha256-GxHOWJcRBBHVm/RLeXChSDg59sX6dnO+yKyNEvUNup4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.date=unknown"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "okms version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/ovh/okms-cli";
    changelog = "https://github.com/ovh/okms-cli/releases/tag/v${finalAttrs.version}";
    description = "Command Line Interface to interact with your OVHcloud KMS services";
    mainProgram = "okms";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
})
