{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    tag = "v${version}";
    hash = "sha256-J2gR1KJh8mMp9VA3GwXyvg1yM5doMw+X/5zOik0tDm8=";
  };

  vendorHash = "sha256-4E7qtP0w/c1LLJ/pNBJFosl1K3ycq4HLfjO0CmHaT3k=";

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
