{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "issue2md";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "bigwhite";
    repo = "issue2md";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jwMaXiGcdNCQZJ2xht1oAcFJohFJiTH3lV3+opZ677g=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI tool to convert GitHub issue into Markdown file";
    homepage = "https://github.com/bigwhite/issue2md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "issue2md";
  };
})
