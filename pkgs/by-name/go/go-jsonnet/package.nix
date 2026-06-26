{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "go-jsonnet";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-jsonnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O7b26aobvs1gHsUNM2RZ/WnIMpFJOa/XbupttTMJ8LA=";
  };

  vendorHash = "sha256-uFCvMmiZVaRYhaORI92W0pkDjDZNiWIcop70FssJiZo=";

  subPackages = [ "cmd/jsonnet*" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Implementation of Jsonnet in pure Go";
    homepage = "https://github.com/google/go-jsonnet";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nshalman
    ];
    mainProgram = "jsonnet";
  };
})
