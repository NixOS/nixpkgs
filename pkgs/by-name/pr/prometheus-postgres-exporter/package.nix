{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "sha256-YzMQd52esY51/kDYdA75tQcaDPHyJeJf2WRftsSOKwk=";
  };

  vendorHash = "sha256-ip19YaioInP2MsFwPVnmde3kX/SYLPqsdbS96hPJG2w=";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postgres; };

  meta = {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for PostgreSQL";
    mainProgram = "postgres_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fpletz
      globin
      ma27
    ];
  };
}
