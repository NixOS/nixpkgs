{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cuelsp";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "cuelsp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+E49TR2D26HSTwgwO1XFkIwXr5lmvv9l3KtR8dVT/cQ=";
  };

  vendorHash = "sha256-zg4aXPY2InY5VEX1GLJkGhMlfa5EezObAjIuX/bGvlc=";

  doCheck = false;

  subPackages = [
    "cmd/cuelsp"
  ];

  meta = {
    description = "Language Server implementation for CUE, with built-in support for Dagger";
    mainProgram = "cuelsp";
    homepage = "https://github.com/dagger/cuelsp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sagikazarmark ];
  };
})
