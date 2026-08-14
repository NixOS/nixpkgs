{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mysqld_exporter";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "mysqld_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EIC6jTYrYtVUSYL0VqCBmKjXrFGX3zP3SvfB6ikBfD4=";
  };

  vendorHash = "sha256-tgch9lijU013k39uUN4+RtoKGVjmYQrNz00kfy65ci4=";

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
