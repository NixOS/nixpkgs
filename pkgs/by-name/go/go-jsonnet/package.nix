{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "go-jsonnet";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-jsonnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J92xNDpCidbiSsN6NveS6BX6Tx+qDQqkgm6pjk1wBTQ=";
  };

  vendorHash = "sha256-Uh2rAXdye9QmmZuEqx1qeokE9Z9domyHsSFlU7YZsZw=";

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
