{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pluto";
  version = "5.22.7";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lB8xMkKCnQYMtwvYXbCwSsh30nbpQ/2Pl8dHA1R3bQg=";
  };

  vendorHash = "sha256-PVax9C1tSlB8AVhJbRx4l5kvOrPfWd4O8jQ2lXoamls=";

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
