{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "okms-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "okms-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y07W8XuPrQ+47PdKddUhuk9S1bsAfxAfPXQCAl8mXak=";
  };

  vendorHash = "sha256-TjFmFdDAZ5TfIcPyCnMMJNwlStSrOfBMUPAbuorE08Q=";

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

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/ovh/okms-cli";
    changelog = "https://github.com/ovh/okms-cli/releases/tag/${finalAttrs.src.tag}";
    description = "Command Line Interface to interact with your OVHcloud KMS services";
    mainProgram = "okms";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
})
