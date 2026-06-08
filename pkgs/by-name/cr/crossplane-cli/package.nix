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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E1Dp0ovC2FWwsrSvhVWudHXxke2z2nCg0q8CVDg58/Y=";
  };

  vendorHash = "sha256-uGQ1lrj+V0ndnTJTKtN6GLGLv89RPDb/Vuo58XYqV8M=";

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
