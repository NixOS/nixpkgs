{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    rev = "v${version}";
    hash = "sha256-r3gp0f771Cfy4JNekilnct+FKu4nOb+8y+B1A+anJ5Y=";
  };

  vendorHash = "sha256-5oKcq1eTrcjQKWySDOsEFFbKkld9g494D5Tg9Bej8JQ=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=v${version}" ];

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
