{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    rev = "v${version}";
    hash = "sha256-CnREcPXNehxOMZm/cuedkDeWtloc7TGWNmmoFZhSTZE=";
  };

  vendorHash = "sha256-tSQjCdgEXIGlSWcIB6lLQulAiEAebgW3pXL9Z2ujgIs=";

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
