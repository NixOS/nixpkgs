{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "grafana-dash-n-grab";
  version = "0.8.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "esnet";
    repo = "gdg";
    sha256 = "sha256-Rt7MUiC8zTL4Ni18FKdzkk30G5fCH6ZxBxpHePO3/LE=";
  };

  vendorHash = "sha256-3BR3tB2CLT7aT+0DsKqA3rwle1RoJRv1/i38HBYkL/0=";

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
    teams = [ lib.teams.bitnomial ];
    mainProgram = "gdg";
    changelog = "https://github.com/esnet/gdg/releases/tag/v${version}";
  };
}
