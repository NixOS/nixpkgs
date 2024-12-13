{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  rpm,
  xz,
}:

buildGoModule rec {
  pname = "clair";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-itIjDdTKQ0PCfOkefXxqu6MpdWK3F1j6ArvaInQd/hc=";
  };

  vendorHash = "sha256-CpIOQiEjQGC6qeoxRS/jFohUnELefAX0KOERudL6BGM=";

  nativeBuildInputs = [
    makeWrapper
  ];

  subPackages = [
    "cmd/clair"
    "cmd/clairctl"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/clair \
      --prefix PATH : "${
        lib.makeBinPath [
          rpm
          xz
        ]
      }"
  '';

  meta = with lib; {
    description = "Vulnerability Static Analysis for Containers";
    homepage = "https://github.com/quay/clair";
    changelog = "https://github.com/quay/clair/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
