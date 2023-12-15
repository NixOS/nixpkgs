{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "crossplane-cli";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "crossplane";
    rev = "v${version}";
    hash = "sha256-rxN0Zi1UgQjDOkY2OJlG6826ARBzlEObJk4nDEc9784=";
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
