{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "expr";
<<<<<<< HEAD
  version = "1.17.7";
=======
  version = "1.17.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "expr-lang";
    repo = "expr";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-OKKbEgJgQWL5jP+E8ZuxdVjZ89QjLy6AAPRepe4jWsk=";
=======
    hash = "sha256-XYKdRIEXOVVXXYdgBKDDl1vzvzntHYtVeDFvMs8ECms=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${src.name}/repl";

<<<<<<< HEAD
  vendorHash = "sha256-NIcHf9P2/1Me+LuWA3BEjA2mOgdSzXFQJPrhAT7uPoo=";
=======
  vendorHash = "sha256-N23oxNppzsH4iD0g3IrOj43ZBb+lEm6BA/G7TUcoKbY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/{repl,expr}
  '';

<<<<<<< HEAD
  meta = {
    description = "Expression language and expression evaluation for Go";
    homepage = "https://github.com/expr-lang/expr";
    changelog = "https://github.com/expr-lang/expr/releases/tag/${src.rev}";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Expression language and expression evaluation for Go";
    homepage = "https://github.com/expr-lang/expr";
    changelog = "https://github.com/expr-lang/expr/releases/tag/${src.rev}";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "expr";
  };
}
