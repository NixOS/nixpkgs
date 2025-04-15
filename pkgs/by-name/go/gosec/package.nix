{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.22.3";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MQ/dDK2t9H7bSsr5MMtlKySLAJIDimRbpATHyOYxrBo=";
  };

  vendorHash = "sha256-R1w+dHx3Aond6DmwCHRVZXmUABWfpsbLgcDW67Ukz0E=";

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
