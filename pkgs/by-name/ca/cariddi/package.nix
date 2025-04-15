{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    tag = "v${version}";
    hash = "sha256-AYB2Ebc+OlB8kaW14o1SPAmbWFducfRGmn21YhV1SGs=";
  };

  vendorHash = "sha256-Em/h1Xv4CdENykDqZMcru+Z09fVdxi9bGfFU+uRwI3o=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    changelog = "https://github.com/edoardottt/cariddi/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "cariddi";
  };
}
