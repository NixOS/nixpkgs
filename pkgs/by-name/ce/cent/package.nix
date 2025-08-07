{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cent";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "xm1k3";
    repo = "cent";
    tag = "v${version}";
    hash = "sha256-howKTFmVUZsjS2+RlAijcMSF1nXOb/mbEPLVq84c6Ec=";
  };

  vendorHash = "sha256-seb04GuK35wNpNBqYSyJ+JaI453mh8h/z+fl8r21aSE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to handle Nuclei community templates";
    homepage = "https://github.com/xm1k3/cent";
    changelog = "https://github.com/xm1k3/cent/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "cent";
  };
}
