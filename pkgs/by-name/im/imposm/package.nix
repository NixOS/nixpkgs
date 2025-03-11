{
  lib,
  buildGoModule,
  fetchFromGitHub,
  leveldb,
  geos,
}:

buildGoModule rec {
  pname = "imposm";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "omniscale";
    repo = "imposm3";
    tag = "v${version}";
    hash = "sha256-PF7pi2UTZJe7WzfaJrQrOGusO/RRfh8KNz8YyrVcBvg=";
  };

  vendorHash = null;

  buildInputs = [
    leveldb
    geos
  ];

  ldflags = [
    "-s -w"
    "-X github.com/omniscale/imposm3.Version=${version}"
  ];

  # requires network access
  doCheck = false;

  meta = {
    description = "Imposm imports OpenStreetMap data into PostGIS";
    homepage = "https://imposm.org/";
    changelog = "https://github.com/omniscale/imposm3/releases/tag/${src.rev}";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "imposm";
  };
}
