{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cel-go";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "cel-expr";
    repo = "cel-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yjWQCo7vyujW03Y6c5DKyLCLGJHaxBoMX/MEkv3eEcM=";
  };

  modRoot = "repl";

  vendorHash = "sha256-7oI9hMcN1MixjjyvR06AUk3RBVc9jpOHYw8C30GXsSw=";

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
