{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.14.5";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${version}";
    hash = "sha256-faIjS3B019eYefOIklJMuUVcCzkM3bHu/HJ1kaERtUA=";
  };

  vendorHash = "sha256-mh66gH4ln/D2OWaD+VISTysszjpPGg2dHF29BD1i6z8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
}
