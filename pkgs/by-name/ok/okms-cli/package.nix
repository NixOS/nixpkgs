{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "okms-cli";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "okms-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zYhK2ulFVw7XlhoKrN9JoZg8lUFisfKS/Iez+Ll0eME=";
  };

  vendorHash = "sha256-LFZ4dsWnODHLFc6k7p+Rd3zR0befCSOZLanwUFIWRl0=";

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
