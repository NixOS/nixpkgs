{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, testers
, crossplane-cli
}:

buildGoModule rec {
  pname = "crossplane-cli";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "crossplane";
    rev = "v${version}";
    hash = "sha256-VwnKTeCfCgKlgh+6QO2J4r1ImAq0zlxFFdhTtC95bs0=";
  };

  vendorHash = "sha256-+e3NuSCvUgZANDB9LsvlQn3h9+L1NeQeURKDZd21reo=";

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
