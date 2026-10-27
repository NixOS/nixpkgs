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
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ksym0FzurF2fkpKtIiTJ184Wzj4Xz48uCUPSBUeSgbg=";
  };

  vendorHash = "sha256-FUzdO47z53XVQ3DLUKXe9TF2LogsSzobz13bzEmkH1U=";

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
    changelog = "https://github.com/crossplane/cli/releases/tag/v${finalAttrs.version}";
    description = "Utility to make using Crossplane easier";
    mainProgram = "crossplane";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      selfuryon
      LorenzBischof
    ];
  };
})
