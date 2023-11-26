{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krelay";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hyjseBIyPdY/xy163bGtfNR1rN/cQczJO53gu4/WmiU=";
  };

  vendorHash = "sha256-uDLc1W3jw3F+23C5S65Tcljiurobw4IRw7gYzZyBxQ0=";

  subPackages = [ "cmd/client" ];

  ldflags = [ "-s" "-w" "-X github.com/knight42/krelay/pkg/constants.ClientVersion=${version}" ];

  postInstall = ''
    mv $out/bin/client $out/bin/kubectl-relay
  '';

  meta = with lib; {
    description = "A better alternative to `kubectl port-forward` that can forward TCP or UDP traffic to IP/Host which is accessible inside the cluster.";
    homepage = "https://github.com/knight42/krelay";
    changelog = "https://github.com/knight42/krelay/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky ];
    mainProgram = "kubectl-relay";
  };
}
