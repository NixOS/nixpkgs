{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "krelay";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tZnHkjsAT8AOIpVDIiHnD6k/2S/S/+jM9uw18TaYJaA=";
  };

  vendorHash = "sha256-5lA7I/vrc6+XsiSCL61a/p7jbseLcJyXnOC5R/z85vQ=";

  subPackages = [ "cmd/client" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/knight42/krelay/pkg/constants.ClientVersion=${version}"
  ];

  postInstall = ''
    mv $out/bin/client $out/bin/kubectl-relay
  '';

  meta = with lib; {
    description = "Drop-in replacement for `kubectl port-forward` with some enhanced features";
    homepage = "https://github.com/knight42/krelay";
    changelog = "https://github.com/knight42/krelay/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky ];
    mainProgram = "kubectl-relay";
  };
}
