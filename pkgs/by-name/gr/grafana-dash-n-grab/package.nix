{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "grafana-dash-n-grab";
  version = "0.9.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "esnet";
    repo = "gdg";
    sha256 = "sha256-pgfIutJkpH4oELEQu1/3vJ1RPVLF+r4EAV3KpOLZixY=";
  };

  vendorHash = "sha256-MXWJ/riQTzAgUNJWvAzSvdHTAzRymlHheeNyJoKGAF4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X github.com/esnet/gdg/version.GitCommit=${src.rev}"
  ];

  # The test suite tries to communicate with a running version of grafana locally. This fails if
  # you don't have grafana running.
  doCheck = false;

  meta = {
    description = "Grafana Dash-n-Grab (gdg) -- backup and restore Grafana dashboards, datasources, and other entities";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/esnet/gdg";
    maintainers = with lib.maintainers; [
      cdepillabout
      wraithm
    ];
    mainProgram = "gdg";
    changelog = "https://github.com/esnet/gdg/releases/tag/v${version}";
  };
}
