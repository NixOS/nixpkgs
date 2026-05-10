{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gosec";
  version = "2.26.1";

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/iurQn0fNTonpSSFf1llmFA5+CYSb/vYFGE0JKbcL90=";
  };

  vendorHash = "sha256-57fYXBbir4jPiYPtTH1iVNFPWZWfq/Sx21Z4jC3fEWs=";

  subPackages = [
    "cmd/gosec"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.GitTag=${finalAttrs.src.rev}"
    "-X main.BuildDate=unknown"
  ];

  meta = {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    mainProgram = "gosec";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalbasit
      nilp0inter
    ];
  };
})
