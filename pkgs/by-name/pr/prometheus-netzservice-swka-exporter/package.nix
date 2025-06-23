{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

let
  version = "0.0.1";
  src = fetchFromGitea {
    domain = "git.project-insanity.org";
    owner = "onny";
    repo = "netzservice-swka-exporter";
    # rev = "v${version}";
    rev = "9297b7bb7e08f0bf66a94ef0ce9c0eb1a8e4c29b";
    hash = "sha256-FVoPSY5emWU//0hSkAvMbhK1IUB9H44XcpMN8NVmcNw=";
  };
in
buildGoModule {
  pname = "prometheus-netzservice-swka-exporter";
  vendorHash = "sha256-IDFdB86/pL3TiHjRdk/4+PR9XbV0/8EApAHU071DfRI=";
  inherit src version;

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${src.rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
  ];

  meta = {
    description = "Prometheus exporter for Netzservice-SWKA customer accounts";
    homepage = "https://git.project-insanity.org/onny/netzservice-swka-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "netzservice-swka-exporter";
  };
}
