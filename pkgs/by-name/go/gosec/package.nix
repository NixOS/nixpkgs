{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.22.10";

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "v${version}";
    hash = "sha256-KQfQ6RDrnO13emfjiQn+zSI+3Zj9hLWhdLZbAmQBdT0=";
  };

  vendorHash = "sha256-kH7bD4CqFgnw5kuPKyQkwGYUuzkQEmuw7T8fxQ46h3o=";

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

  meta = {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    mainProgram = "gosec";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalbasit
      nilp0inter
    ];
  };
}
