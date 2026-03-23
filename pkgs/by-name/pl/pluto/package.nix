{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pluto";
  version = "5.23.5";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jV5osPpAQk161IBQZkL5J+zZH0ewWeSW8D/8Zlj+6JE=";
  };

  vendorHash = "sha256-gk4AhSbFdbC3bTy/bFL1Evm8b6RlgoMybWdacRlluN8=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true; # for tests

  meta = {
    homepage = "https://github.com/FairwindsOps/pluto";
    description = "Find deprecated Kubernetes apiVersions";
    mainProgram = "pluto";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
})
