{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "expr";
  version = "1.17.6";

  src = fetchFromGitHub {
    owner = "expr-lang";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-XYKdRIEXOVVXXYdgBKDDl1vzvzntHYtVeDFvMs8ECms=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-N23oxNppzsH4iD0g3IrOj43ZBb+lEm6BA/G7TUcoKbY=";

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
    maintainers = [ ];
    mainProgram = "expr";
  };
}
