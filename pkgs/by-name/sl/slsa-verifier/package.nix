{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "slsa-verifier";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "slsa-framework";
    repo = "slsa-verifier";
    rev = "v${version}";
    hash = "sha256-9C6MQwOxcRlhkWslHGr1mR6i2c32HMu7wRmozI4dRPI=";
  };

  vendorHash = "sha256-L+QoXVxj6bNKkH5vcr+2UsZa+NC+Gn+Nno5vW2YEARw=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cli/slsa-verifier" ];

  tags = [ "netgo" ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=${version}"
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/slsa-framework/slsa-verifier";
    changelog = "https://github.com/slsa-framework/slsa-verifier/releases/tag/v${version}";
    description = "Verify provenance from SLSA compliant builders";
    mainProgram = "slsa-verifier";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      mlieberman85
    ];
  };
}
