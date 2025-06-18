{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "grafana-dash-n-grab";
  version = "0.7.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "esnet";
    repo = "gdg";
    sha256 = "sha256-0F4kdyQ4TXV2vb2IkPx7CisTmJAQjlSRtOAFhmZqaD8=";
  };

  vendorHash = "sha256-Ufg4eeSLRHFkI577hPT5KWOf82o7//Y3n5GAlZl8IoQ=";

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
