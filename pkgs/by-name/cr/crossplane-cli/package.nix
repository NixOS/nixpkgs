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
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "crossplane";
    rev = "v${version}";
    hash = "sha256-HSTECDo6jPa9yXziWxPnOvtCC0Xai6yG2orAn1AfAGw=";
  };

  vendorHash = "sha256-0Oefkc/T8ukPvbVgnvI+2rUAectTxawm/XR1KG04LpM=";

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

  meta = with lib; {
    homepage = "https://www.crossplane.io/";
    changelog = "https://github.com/crossplane/crossplane/releases/tag/v${version}";
    description = "Utility to make using Crossplane easier";
    mainProgram = "crossplane";
    license = licenses.asl20;
    maintainers = with maintainers; [ selfuryon ];
  };
}
