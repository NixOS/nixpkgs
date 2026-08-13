{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-snowflake-exporter";
  # No tagged release upstream (only a moving `latest` tag), so pin the commit and
  # use nixpkgs' unstable versioning. Bump the date + rev on update.
  version = "0-unstable-2026-07-02";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "snowflake-prometheus-exporter";
    rev = "d9447d3401aa81b26c091775606c502bf8e2d7cd";
    hash = "sha256-3yaZ2kk2k5ivUNgRNazYjA38zY4dvsTOrkvftQpCW5A=";
  };

  vendorHash = "sha256-HvlZ5g1LqAoXuFuidmHCMTeFfivqUR2ryAh0hQayxnc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.BuildUser=nixbld@nixpkgs"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Prometheus exporter for Snowflake metrics";
    homepage = "https://github.com/grafana/snowflake-prometheus-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rhousand ];
    mainProgram = "snowflake-exporter";
  };
})
