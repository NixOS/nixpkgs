{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    rev = "v${version}";
    hash = "sha256-TEQDjtSMJFZAYCoYXHmJxpxadYyd5DTo7HUhjglLRG8=";
  };

  vendorHash = "sha256-KRjMEH17cvSjtRP/qYeWRFUo6f6v1ZxEd+H3xvZ1udQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=v${version}"
  ];

  postInstall = ''
    mv $out/bin/go-pmtiles $out/bin/pmtiles
  '';

  meta = with lib; {
    description = "Single-file utility for creating and working with PMTiles archives";
    homepage = "https://github.com/protomaps/go-pmtiles";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members ++ (with maintainers; [ theaninova ]);
    mainProgram = "pmtiles";
  };
}
