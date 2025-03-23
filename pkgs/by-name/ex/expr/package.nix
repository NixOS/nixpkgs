{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "expr";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "expr-lang";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-D5hMnihKcSXQUII9L0UmC/fMuFuyqBrgR4yXbYvakn0=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-YtYeAJI7J1nalVt4Phl06Xe/8YdU6egbMjYfbo91b/0=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/{repl,expr}
  '';

  meta = with lib; {
    description = "Expression language and expression evaluation for Go";
    homepage = "https://github.com/expr-lang/expr";
    changelog = "https://github.com/expr-lang/expr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "expr";
  };
}
