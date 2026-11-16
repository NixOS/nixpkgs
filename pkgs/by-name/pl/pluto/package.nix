{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pluto";
  version = "5.24.5";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mxZxzFonMqdBAkWgZoHIhIGeVrTW2UJiBKKif5tWOGw=";
  };

  vendorHash = "sha256-GHgRHYLHTKePzvdsi55RrkUhuifoCmd4QkpQcxMmmNU=";

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
