{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    rev = "v${version}";
    hash = "sha256-eOcjJPQ5a9d1iDaTa+oZgMmyaOszd2ORaKKr3Td4WP0=";
  };

  vendorHash = "sha256-NQ74rLYhzacOrw6Tl6WoERfqbx2aF9X18rh0oOjCotE=";

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
