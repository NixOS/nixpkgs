{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  crossplane-cli,
}:

buildGoModule rec {
  pname = "crossplane-cli";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "crossplane";
    rev = "v${version}";
    hash = "sha256-EIDrBQmtMaHlapVNUYABKejIj1I02g5R5h4cADZvtAg=";
  };

  vendorHash = "sha256-8VqKtWbnDGbmgxT13v2d4+nXHouZ4hi2c2m66SAd1KM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/crossplane/crossplane/internal/version.version=v${version}"
  ];

  subPackages = [ "cmd/crank" ];

  postInstall = ''
    mv $out/bin/crank $out/bin/crossplane
  '';

  passthru.tests.version = testers.testVersion {
    package = crossplane-cli;
    command = "crossplane version || true";
    version = "v${version}";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.crossplane.io/";
    changelog = "https://github.com/crossplane/crossplane/releases/tag/v${version}";
    description = "Utility to make using Crossplane easier";
    mainProgram = "crossplane";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ selfuryon ];
  };
}
