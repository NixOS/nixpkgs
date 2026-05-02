{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "asciigraph";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = "asciigraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K1rNhaA0qvVRMBjaMifqTPq9dc5ttwb+Ivo10da6YOY=";
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
