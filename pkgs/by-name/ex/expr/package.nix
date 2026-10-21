{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "expr";
  version = "1.17.8";

  src = fetchFromGitHub {
    owner = "expr-lang";
    repo = "expr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MJM7ezZtSdDaUewNGACOKvWc+ZOPVScTuW+d6n1K5jo=";
  };

  sourceRoot = "${finalAttrs.src.name}/repl";

  vendorHash = "sha256-GH7rn0q/YuGBx0rrfHa2EMCsynQ3Pgtz1yDsD/NIKsU=";

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
    changelog = "https://github.com/expr-lang/expr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "expr";
  };
})
