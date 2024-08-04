{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    rev = "v${version}";
    hash = "sha256-ZwTZtMNgQE0AIbxdjA+8CFKSp1B9QnV5wmP+z/JoIpg=";
  };

  vendorHash = "sha256-Buzk+rPSPrs0q+g6MWVb47cAIKMxsNXlj3CWA0JINXM=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=v${version}" ];

  postInstall = ''
    mv $out/bin/go-pmtiles $out/bin/pmtiles
  '';

  meta = with lib; {
    description = "Single-file utility for creating and working with PMTiles archives";
    homepage = "https://github.com/protomaps/go-pmtiles";
    license = licenses.bsd3;
    maintainers = [ maintainers.theaninova ];
    mainProgram = "pmtiles";
  };
}
