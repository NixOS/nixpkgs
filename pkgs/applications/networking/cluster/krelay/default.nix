{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krelay";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TonkGh4j+xLGgSpspCedg6c2NpIZIzp5pv8VtWFssPk=";
  };

  vendorHash = "sha256-Qz3q/503A5QmsgEaDqChxS2tcUEJGmeT6YE6R3LBbcY=";

  subPackages = [ "cmd/client" ];

  ldflags = [ "-s" "-w" "-X github.com/knight42/krelay/pkg/constants.ClientVersion=${version}" ];

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
