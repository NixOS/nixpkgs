{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  okms-cli,
  testers,
}:

buildGoModule rec {
  pname = "okms-cli";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "okms-cli";
    tag = "v${version}";
    hash = "sha256-inDE/Vexn7efzxfa/ali+mhyioBWjDPRlDznYyChTtI=";
  };

  vendorHash = "sha256-l8Z5cAfWHWz8mBVioltuNg+jaNwySU/Y4z3z2X86h/s=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=unknown"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = okms-cli;
      command = "okms version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/ovh/okms-cli";
    changelog = "https://github.com/ovh/okms-cli/releases/tag/v${version}";
    description = "Command Line Interface to interact with your OVHcloud KMS services";
    mainProgram = "okms";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
}
