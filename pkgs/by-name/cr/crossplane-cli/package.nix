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
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "crossplane";
    rev = "v${version}";
    hash = "sha256-jNaWedK9h4pP+0u1UDHoZ/7l6kVXA2g9Vs0036itk9Q=";
  };

  vendorHash = "sha256-vYbTkdX3L/AZN9vWUw8NzkPk16BwUzP8zJb22fnsoRo=";

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
    command = "crossplane --version";
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
