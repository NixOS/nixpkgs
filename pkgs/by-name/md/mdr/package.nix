{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "mdr";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "MichaelMure";
    repo = "mdr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ibM3303pXnseAFP9qFTOzj0G/SxRPX+UeRfbJ+MCABk=";
  };

  vendorHash = "sha256-5jzU4EybEGKoEXCFhnu7z4tFRS9fgf2wJXhkvigRM0E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.GitCommit=${finalAttrs.src.rev}"
    "-X main.GitLastTag=${finalAttrs.version}"
    "-X main.GitExactTag=${finalAttrs.version}"
  ];

  meta = {
    description = "MarkDown Renderer for the terminal";
    homepage = "https://github.com/MichaelMure/mdr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "mdr";
  };
})
