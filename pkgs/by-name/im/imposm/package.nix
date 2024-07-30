{ lib, buildGoModule, fetchFromGitHub, leveldb, geos }:

buildGoModule rec {
  pname = "imposm";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "omniscale";
    repo = "imposm3";
    rev = "v${version}";
    hash = "sha256-4PwJzR/xeVdqAiHXzMAqI2m8qeqFXLZxy9V3o59eKwA=";
  };

  vendorHash = null;

  buildInputs = [ leveldb geos ];

  ldflags = [
    "-s -w"
    "-X github.com/omniscale/imposm3.Version=${version}"
  ];

  # requires network access
  doCheck = false;

  meta = with lib; {
    description = "Imposm imports OpenStreetMap data into PostGIS";
    homepage = "https://imposm.org/";
    changelog = "https://github.com/omniscale/imposm3/releases/tag/${src.rev}";
    license = licenses.apsl20;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "imposm";
  };
}
