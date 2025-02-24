{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    tag = "v${version}";
    hash = "sha256-sX+rEXCmDqHP6GZ5QdvJLBaJsuAhvRQSm+htlQiyYDk=";
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

  meta = {
    description = "Single-file utility for creating and working with PMTiles archives";
    homepage = "https://github.com/protomaps/go-pmtiles";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.geospatial.members ++ (with lib.maintainers; [ theaninova ]);
    mainProgram = "pmtiles";
  };
}
