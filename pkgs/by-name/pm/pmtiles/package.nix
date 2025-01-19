{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    rev = "v${version}";
    hash = "sha256-W8TlMUAzEeHYrVxJTS3CeBkZzshpuDbFD8lC/ITJMKI=";
  };

  vendorHash = "sha256-Oi099KdfSSVDKuWektEucigwchjEHCsOxbCe48DICF8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=v${version}"
  ];

  postInstall = ''
    mv $out/bin/go-pmtiles $out/bin/pmtiles
  '';

  meta = {
    description = "Single-file utility for creating and working with PMTiles archives";
    homepage = "https://github.com/protomaps/go-pmtiles";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.geospatial.members ++ (with lib.maintainers; [ theaninova ]);
    mainProgram = "pmtiles";
  };
}
