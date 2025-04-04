{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    tag = "v${version}";
    hash = "sha256-ixjHPO0FXKbWOfjMVz1YD+wWpL8wcn2CCO46KF1zb0U=";
  };

  vendorHash = "sha256-7v92+iDAYG0snJjVCX35rLKV/ZEzaVX2au4HOwa/ILU=";

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
