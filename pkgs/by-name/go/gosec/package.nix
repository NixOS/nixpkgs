{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.22.7";

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "v${version}";
    hash = "sha256-px5KfToXE3jhCQC/OKlFEFvYD9zVRl0qN24SRARaUyw=";
  };

  vendorHash = "sha256-0XYYPbbuqmBRsNDjUv1cgnQRzYFBn/sWJG6tMExRk3U=";

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
