{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dependency-track-exporter";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jetstack";
    repo = "dependency-track-exporter";
    tag = "v${version}";
    hash = "sha256-yvScGxgkyZzEdfeJCXk/tSk3cLW+jyw00XbJVrpU6MY=";
  };

  vendorHash = "sha256-bEJFTsGQMDfZOt67ouv3PkKy+De4mL9Yk7iuslo1qYU=";

  ldflags = [
    "-X=github.com/prometheus/common/version.Version=${version}"
    "-X=github.com/prometheus/common/version.Revision=${src.rev}"
    "-X=github.com/prometheus/common/version.Branch=${src.rev}"
    "-X=github.com/prometheus/common/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "Helper to export Prometheus metrics for Dependency-Track";
    homepage = "https://github.com/jetstack/dependency-track-exporter";
    changelog = "https://github.com/jetstack/dependency-track-exporter/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dependency-track-exporter";
  };
}
