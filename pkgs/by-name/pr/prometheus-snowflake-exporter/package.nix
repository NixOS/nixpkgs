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
  version = "0-unstable-2026-11-12";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "snowflake-prometheus-exporter";
    rev = "4a87f633ca0d63aadc50baed553cc04d89b0b9e0";
    hash = "sha256-eTgtdWo8S6L9/4gdawaXUzQWrMnhUOqmrQEfuKHVWWE=";
  };

  vendorHash = "sha256-QukE6bYvEo98kSJ3Qjnj+cPOjo4XhFSY3bs2guf7bjE=";

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
    extraArgs = [
      "--version=branch"
      "--version-regex=(\\d.*)"
    ];
  };

  meta = {
    description = "Prometheus exporter for Snowflake metrics";
    homepage = "https://github.com/grafana/snowflake-prometheus-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rhousand ];
    mainProgram = "snowflake-exporter";
  };
})
