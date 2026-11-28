{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "expr";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "expr-lang";
    repo = "expr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSaCGzP3rSaaABXKwKgKRQBPkMtZWYN3ORiPX55ErNk=";
  };

  sourceRoot = "${finalAttrs.src.name}/repl";

  vendorHash = "sha256-EBbNxPzumNWhiKl1a3sdQbd8Qou+sx2qRec3Jtbzc4k=";

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
