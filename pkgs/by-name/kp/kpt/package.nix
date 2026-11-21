{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "kpt";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kptdev";
    repo = "kpt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HHqjBLSS3BYGJEvjgn/42ydRI/rmSrMLIaSZJlVyPV8=";
  };

  vendorHash = "sha256-G7634QruXFTDEO+hS1GImsvrpMbEn1WabX+E2YW/LlA=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kptdev/kpt/run.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Automate Kubernetes Configuration Editing";
    mainProgram = "kpt";
    homepage = "https://github.com/kptdev/kpt";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
