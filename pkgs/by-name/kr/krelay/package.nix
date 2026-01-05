{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "krelay";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = "krelay";
    rev = "v${version}";
    hash = "sha256-v7yX5wDf3d07TiWe+9iTkGhc8LqfU1hUkxuf5ZBVcYE=";
  };

  vendorHash = "sha256-9bOU9Zqqb4tdQCIB3UkTdAcD4cn6+7C35gOCywv1/Os=";

  subPackages = [ "cmd/client" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/knight42/krelay/pkg/constants.ClientVersion=${version}"
  ];

  postInstall = ''
    mv $out/bin/client $out/bin/kubectl-relay
  '';

  meta = {
    description = "Drop-in replacement for `kubectl port-forward` with some enhanced features";
    homepage = "https://github.com/knight42/krelay";
    changelog = "https://github.com/knight42/krelay/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivankovnatsky ];
    mainProgram = "kubectl-relay";
  };
}
