{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "issue2md";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "bigwhite";
    repo = "issue2md";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bbID2yJkVdzWJ+LcQCTTeoMsQpJdT4op9PhTDwr+D+A=";
  };

  vendorHash = null;

  meta = {
    description = "CLI tool to convert GitHub issue into Markdown file";
    homepage = "https://github.com/bigwhite/issue2md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "issue2md";
  };
})
