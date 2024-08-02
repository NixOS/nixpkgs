{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Kzo8iWj4mtnX1Jxm2sLsnmEOmpzScxWHZ/sLYYm3vQI=";
  };

  vendorHash = "sha256-cEUlCR/xtPJJSWplV1COwV6UfzSmVArF4V0pJRk+/Og=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" "-X main.date=unknown" ];

  meta = with lib; {
    homepage = "https://github.com/vishen/go-chromecast";
    description = "CLI for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "go-chromecast";
  };
}
