{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  name = "regal";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-hacpTx19DVm2MMm2UdfGlgcNhxZCVVskqO1Z4KDPV+M=";
  };

  vendorHash = "sha256-D1ti8wAJewTScWojAPva7gdgBJSZBr0Ruvd7NEXAB+k=";

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
