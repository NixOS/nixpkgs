{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    tag = "v${version}";
    hash = "sha256-hhzzSEuraer3oQwpNZn4ROASYKQHsnwZs+XHuJ8MkK4=";
  };

  vendorHash = "sha256-GvgH6i2t3O39gG2hsKsv5xbLb1V1qi3MqVSfw2D+cZg=";

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
