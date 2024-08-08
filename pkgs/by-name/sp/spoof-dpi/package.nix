{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "spoof-dpi";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "refs/tags/v${version}";
    hash = "sha256-I93XhIrdCXmoiG6u617toFaB1YALMK8jabCGTp3u4os=";
  };

  vendorHash = "sha256-kmp+8MMV1AHaSvLnvYL17USuv7xa3NnsCyCbqq9TvYE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Simple and fast anti-censorship tool written in Go";
    homepage = "https://github.com/xvzc/SpoofDPI";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Ligthiago ];
    mainProgram = "spoof-dpi";
  };
}
