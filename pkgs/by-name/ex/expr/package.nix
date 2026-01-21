{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "expr";
  version = "1.17.7";

  src = fetchFromGitHub {
    owner = "expr-lang";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-OKKbEgJgQWL5jP+E8ZuxdVjZ89QjLy6AAPRepe4jWsk=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-NIcHf9P2/1Me+LuWA3BEjA2mOgdSzXFQJPrhAT7uPoo=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/{repl,expr}
  '';

  meta = {
    description = "Expression language and expression evaluation for Go";
    homepage = "https://github.com/expr-lang/expr";
    changelog = "https://github.com/expr-lang/expr/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "expr";
  };
}
