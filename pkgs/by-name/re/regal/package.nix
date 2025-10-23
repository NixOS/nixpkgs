{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  name = "regal";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-gdoQ+u9YbwTq28b3gYsNA0SxYFigeKK2JUd0paz8WYQ=";
  };

  vendorHash = "sha256-FycDMCfvpUkW7KcTLMUBOjbU4JnKCJrWQalNKSY1RkM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/styrainc/regal/pkg/version.Version=${version}"
    "-X github.com/styrainc/regal/pkg/version.Commit=${version}"
  ];

  meta = with lib; {
    description = "Linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/StyraInc/regal";
    changelog = "https://github.com/StyraInc/regal/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ rinx ];
  };
}
