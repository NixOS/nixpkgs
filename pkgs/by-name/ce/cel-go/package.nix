{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cel-go";
  version = "0.33.2";

  src = fetchFromGitHub {
    owner = "cel-expr";
    repo = "cel-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FT5XED4ZOgz8I28G5Rn9pPKUoF8P2u8lV87VeI+cxt4=";
  };

  modRoot = "repl";

  vendorHash = "sha256-tYPdQowJq7rPwKau8WIJgLgKXz3XVe7tBCVuEsQTg+8=";

  subPackages = [
    "main"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/{main,cel-go}
  '';

  meta = {
    changelog = "https://github.com/cel-expr/cel-go/releases/tag/${finalAttrs.src.tag}";
    description = "Fast, portable, non-Turing complete expression evaluation with gradual typing";
    homepage = "https://github.com/cel-expr/cel-go";
    license = lib.licenses.asl20;
    mainProgram = "cel-go";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
