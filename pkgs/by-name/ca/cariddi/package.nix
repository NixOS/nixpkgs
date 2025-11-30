{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    tag = "v${version}";
    hash = "sha256-1u8UB4nK3Jqb3Ah+A6yCPqGkVOPJOG/oliJLUCNuVgI=";
  };

  vendorHash = "sha256-nCxAlrIprCbdCHo/5IWriK19bo9sm5NQkJ+EwYCw+Bs=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    changelog = "https://github.com/edoardottt/cariddi/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cariddi";
  };
}
