{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krelay";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KR5lBLgzv9yjL3JvCjg8dxXWmPgagnnKxYtrPunAyXY=";
  };

  vendorHash = "sha256-vaWdJyPOLsrLrhipBvUCOHo/TjnJz4Qpvj3lvUPHomU=";

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
