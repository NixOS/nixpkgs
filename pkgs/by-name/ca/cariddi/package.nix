{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    tag = "v${version}";
    hash = "sha256-FIsbkDqXi/a0hfO8AqqCJgreHidDd3rtSNeu9qDXPZk=";
  };

  vendorHash = "sha256-XEk3U4E0WeDvn6JVBILRj5KD/DFJcz03qglMrPU+ksY=";

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
