{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, testers
, crossplane-cli
}:

buildGoModule rec {
  pname = "crossplane-cli";
  version = "1.14.5";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "crossplane";
    rev = "v${version}";
    hash = "sha256-P7zfkrE+r/pQEEu0GK7v+bJ4ONeejZLXq2sYmU/V110=";
  };

  vendorHash = "sha256-vkXvnEstD/czBDxmI96TIQB/L4jxhMwIS1XpHqVtxqY=";

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
