{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mbtileserver";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "consbio";
    repo = "mbtileserver";
    rev = "v${version}";
    sha256 = "sha256-RLaAhc24zdCFvpSN2LZXNyS1ygg9zCi4jEj8owdreWU=";
  };

  vendorHash = "sha256-yn7LcR/DvHDSRicUnWLrFZKqZti+YQoLSk3mZkDIj10=";

  meta = {
    description = "Simple Go-based server for map tiles stored in mbtiles format";
    mainProgram = "mbtileserver";
    homepage = "https://github.com/consbio/mbtileserver";
    changelog = "https://github.com/consbio/mbtileserver/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.isc;
    teams = [ lib.teams.geospatial ];
  };
}
