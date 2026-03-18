{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mysqld_exporter";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "mysqld_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1K0Xtj7VRAMQK5wgFGj7Yvzae6wVi9wWu1UcnEmpQJU=";
  };

  vendorHash = "sha256-qoJ0vLeJXyYOruNRaXiimixEmcC5bOendAId1VXIhj8=";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.Revision=${finalAttrs.src.rev}"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];

  # skips tests with external dependencies, e.g. on mysqld
  checkFlags = [
    "-short"
  ];

  meta = {
    changelog = "https://github.com/prometheus/mysqld_exporter/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Prometheus exporter for MySQL server metrics";
    mainProgram = "mysqld_exporter";
    homepage = "https://github.com/prometheus/mysqld_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      globin
    ];
  };
})
