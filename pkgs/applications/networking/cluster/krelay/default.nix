{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "krelay";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1sAkNueP8qGwPwdX0oSJfB/oGvna6+G8Cay+3vGJ2IE=";
  };

  vendorHash = "sha256-iv0OJLhIZpdem2/JFirJnvmU44ylTomgB8UqCGqHbwA=";

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
    description = "A drop-in replacement for `kubectl port-forward` with some enhanced features";
    homepage = "https://github.com/knight42/krelay";
    changelog = "https://github.com/knight42/krelay/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky ];
    mainProgram = "kubectl-relay";
  };
}
