{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    tag = "v${version}";
    hash = "sha256-Ti6ljJeC6hqA5edzyUqOShBIbdmrsz4TDnQ44TMJQ8Q=";
  };

  vendorHash = "sha256-kfEzpaFMf0W8Ygtl40LBy3AZQSL+9Uo+n2x9OTOavqk=";

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
    maintainers = with lib.maintainers; [ theaninova ];
    teams = [ lib.teams.geospatial ];
    mainProgram = "pmtiles";
  };
}
