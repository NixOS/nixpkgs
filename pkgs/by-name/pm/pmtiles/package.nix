{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pmtiles";
  version = "1.31.1";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hx20rNKmoxryD+/GClJpbXvjta6TUzaHJIRCu1f+lRU=";
  };

  vendorHash = "sha256-0u/04mpqhpRideIf8eOzgC7ZWNp4P2c2ssQvyWlcD4M=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=v${finalAttrs.version}"
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
})
