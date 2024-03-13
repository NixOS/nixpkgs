{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krelay";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FB+N4gSjAG/HyL5a/D44G4VVzlAQZ8Vjt+YUclCcy3w=";
  };

  vendorHash = "sha256-Nktv3yRrK2AypCzvQDH9gax65GJEXq6Fb3eBWvltQVk=";

  subPackages = [ "cmd/client" ];

  ldflags = [ "-s" "-w" "-X github.com/knight42/krelay/pkg/constants.ClientVersion=${version}" ];

  postInstall = ''
    mv $out/bin/client $out/bin/kubectl-relay
  '';

  meta = with lib; {
    description = "A drop-in replacement for `kubectl port-forward` with some enhanced features";
    homepage = "https://github.com/knight42/krelay";
    changelog = "https://github.com/knight42/krelay/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky ];
    mainProgram = "kubectl-relay";
  };
}
