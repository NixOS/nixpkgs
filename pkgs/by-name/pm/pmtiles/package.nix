{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.19.2";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    rev = "v${version}";
    hash = "sha256-FhX+Hqtrns/MxOk0cTnDEhYmwyGXgkG85zJJ94+G9yk=";
  };

  vendorHash = "sha256-N/8n3NDHShcXjPvLSkLRacY4aqFzLYM/+/mJRGXQAVg=";

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
