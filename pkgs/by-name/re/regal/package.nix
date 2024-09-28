{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "regal";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-IGf7iIL2q3w7qIJ0oxDILxcNjexuEr4bsYK+v24Ae+c=";
  };

  vendorHash = "sha256-Yl8ZFEiAJRAetc3e2ZdrbTdYhx/Ek9nr3mMQ0H7+aGM=";

  ldflags = [
    "-s" "-w"
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
