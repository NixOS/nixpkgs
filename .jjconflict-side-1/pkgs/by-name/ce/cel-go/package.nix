{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cel-go";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "cel-expr";
    repo = "cel-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sFS6Kei7KpNFdjR5pyicTZdIDYZi5Juxab4YzgB25sM=";
  };

  modRoot = "repl";

  vendorHash = "sha256-kJhpVH+Ak2/yICshXreVgPs5W/Cq63l+FwUMW6G1l8k=";

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
