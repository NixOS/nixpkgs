{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "expr";
  version = "1.17.4";

  src = fetchFromGitHub {
    owner = "expr-lang";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-Ss1rs4BiKFOSzfL6VXKZA2Z/LYJ9N+AYkgdVCeintOk=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-mjqbO3qgX7ak8VRFHnz9UYNoOd+bbHBImDLvnaJhdqI=";

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
