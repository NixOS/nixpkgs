{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "expr";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "expr-lang";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-teP/14czczNiz0kxoLNmZQg/AvcDuB8K4jdQpJf5JLQ=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-DamIlXTuuPifGgpbVXn7OPI97ppqlwiCtcZAnQ00YD0=";

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
