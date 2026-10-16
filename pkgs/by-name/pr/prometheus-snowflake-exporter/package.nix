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
  version = "latest-unstable-2026-10-07";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "snowflake-prometheus-exporter";
    rev = "5be547ff96d8c005029dd0e0aec1b894dc5bd042";
    hash = "sha256-d8p5ju/58VGlyVUuC/eXBJsmoVJ2ubhuM9614hPfszw=";
  };

  vendorHash = "sha256-boR8MfNAZuEag0ZLWHM3hZMEx7DwEwoy9OiVcLijV1w=";

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
