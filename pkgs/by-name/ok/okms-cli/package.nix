{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "okms-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "okms-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mAHhmEB2N4TcW1axzNHtsOOc9mlUJS66CZprKIsrFyg=";
  };

  vendorHash = "sha256-/VKa35URUY4K60aN+9saFyzCgCUb0xDDTa8eSXofOtk=";

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
