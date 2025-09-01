{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hednsextractor";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "HuntDownProject";
    repo = "HEDnsExtractor";
    tag = "v${version}";
    hash = "sha256-Uj5TNQ+X0+ip1DcLanMmFzr5ROuXhuZJSPF9tile+ZQ=";
  };

  vendorHash = "sha256-8yD/yHSqesyS71YeRBv4ARyXyIbTcan7YjBeKBrg0Vc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool suite for hunting suspicious targets, expose domains and phishing discovery";
    homepage = "https://github.com/HuntDownProject/HEDnsExtractor";
    changelog = "https://github.com/HuntDownProject/HEDnsExtractor/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hednsextractor";
  };
}
