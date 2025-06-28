{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "grafana-dash-n-grab";
  version = "0.8.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "esnet";
    repo = "gdg";
    sha256 = "sha256-Ou8Yj20q7SGYuFnw3yFvjGHtKE+Uswqfbp9NJztqetU=";
  };

  vendorHash = "sha256-ow5bVwKrvviS7jxpT2xkWX6YufFAM9v7V1o/mNn4Czg=";

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
