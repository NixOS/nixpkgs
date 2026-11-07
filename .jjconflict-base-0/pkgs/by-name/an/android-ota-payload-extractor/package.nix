{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finallAttrs: {
  pname = "android-ota-payload-extractor";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "tobyxdd";
    repo = "android-ota-payload-extractor";
    tag = "v${finallAttrs.version}";
    hash = "sha256-Ln9HSM3mmba5XrzPCmgdn+erGK1v/POz586K/D4krnY=";
  };

  vendorHash = "sha256-JsinGljnb+kC0QgaF4Vbi6Mh3Lwwwk/SbC+p5WLt08A=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A fast & natively cross-platform Android OTA payload extractor written in Go";
    homepage = "https://github.com/tobyxdd/android-ota-payload-extractor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    teams = with lib.teams; [ android ];
    mainProgram = "android-ota-payload-extractor";
  };
})
