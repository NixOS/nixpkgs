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
    rev = "0a72845fb2ce432ae1340af11c84a2586b273fa8";
    hash = "sha256-+Oqjh210mGul8yr+msKnfSMsTIGk7hLeAy6fiF17cac=";
  };
in
buildGoModule {
  pname = "prometheus-netzservice-swka-exporter";
  vendorHash = "sha256-ndX80xhz/KpOJh/vvRpM7oWPL5m8mNdrmvY1ssUN5io=";
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
    mainProgram = "cmd";
  };
}
