{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  crossplane-cli,
}:

buildGoModule (finalAttrs: {
  pname = "crossplane-cli";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pD91bH+K0nWDXv51mWtNlQVtBLi/zDEjAxAJ6ywd69g=";
  };

  vendorHash = "sha256-d7ZgiRF5LVxJoOwqfe0nHyJmakbexGEA7865QXUotP8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/crossplane/crossplane-runtime/v2/pkg/version.version=v${finalAttrs.version}"
  ];

  subPackages = [ "cmd/crossplane" ];

  passthru.tests.version = testers.testVersion {
    package = crossplane-cli;
    command = "crossplane version --client";
    version = "v${finalAttrs.version}";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.crossplane.io/";
    changelog = "https://github.com/crossplane/crossplane/releases/tag/v${finalAttrs.version}";
    description = "Utility to make using Crossplane easier";
    mainProgram = "crossplane";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      selfuryon
      LorenzBischof
    ];
  };
})
