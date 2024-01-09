{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    rev = "v${version}";
    hash = "sha256-8gd6p4AAevtRkb/IZAXfxz8lioySf3s8lT6moi1IoWc=";
  };

  vendorHash = "sha256-gLFwGEUeH41bObG32MZznF7clct3h2GEvdZ2/KIiVb4=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=v${version}" ];

  postInstall = ''
    mv $out/bin/go-pmtiles $out/bin/pmtiles
  '';

  meta = with lib; {
    description = "The single-file utility for creating and working with PMTiles archives";
    homepage = "https://github.com/protomaps/go-pmtiles";
    license = licenses.bsd3;
    maintainers = [ maintainers.theaninova ];
    mainProgram = "pmtiles";
  };
}
