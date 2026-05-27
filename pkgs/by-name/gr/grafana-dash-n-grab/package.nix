{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-dash-n-grab";
  version = "0.9.3";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "esnet";
    repo = "gdg";
    sha256 = "sha256-K8/NhTFfYk9oL2wpRxFLobEx3aW6fx7PzLxf5wFNbFY=";
  };

  vendorHash = "sha256-8ZIu9U6OFRD4pu8K/AUBesX/SRyMkOKi8cdScHBdKnk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X github.com/esnet/gdg/version.GitCommit=${finalAttrs.src.rev}"
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
    changelog = "https://github.com/esnet/gdg/releases/tag/v${finalAttrs.version}";
  };
})
