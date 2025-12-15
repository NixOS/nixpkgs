{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "issue2md";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "bigwhite";
    repo = "issue2md";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IwjG6APsl3iZXlb3+SA0wzxE0um/T1oEe5JROJYlfRk=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
  ];

  meta = {
    description = "CLI tool to convert GitHub issue into Markdown file";
    homepage = "https://github.com/bigwhite/issue2md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "issue2md";
  };
})
