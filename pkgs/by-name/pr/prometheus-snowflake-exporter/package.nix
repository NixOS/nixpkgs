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
  version = "latest-unstable-2026-08-26";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "snowflake-prometheus-exporter";
    rev = "744f67a6217d27d96ea664868cd19fa19595b45c";
    hash = "sha256-UdMU4Z6dOzsMEuctQJBlkI/MxsCrZ4O092F0HSUTgLc=";
  };

  vendorHash = "sha256-QQKTxRBlx6v5gFOpQccYvMkRzwtjYaemheE3CMyA7W8=";

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
