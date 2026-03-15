{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "asciigraph";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = "asciigraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wlalEB6/4RakFT48lRbAtVZCT5UC2shi4pvPmbzr6fA=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/guptarohit/asciigraph";
    description = "Lightweight ASCII line graph ╭┈╯ command line app";
    mainProgram = "asciigraph";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mmahut ];
  };
})
