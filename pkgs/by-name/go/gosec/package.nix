{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.22.1";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iYva3ri2X6A6CAEpmt8xrqL7L9JAZlGcVPeMkWG47Ss=";
  };

  vendorHash = "sha256-a9cgl8oOkGZl4fi/uP+yXgoByNm3+wRQ3n5wSAJz0JQ=";

  subPackages = [
    "cmd/gosec"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.GitTag=${src.rev}"
    "-X main.BuildDate=unknown"
  ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    mainProgram = "gosec";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kalbasit
      nilp0inter
    ];
  };
}
