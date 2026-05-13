{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "node_exporter";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "node_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AoW4JO9V/sZDjonNT+Ar8saX/rlb1lB/+Vmu5qGtTlA=";
  };

  vendorHash = "sha256-qTuzF4xeF0riOedwaUR4x/U6Jb0j+GIwUfUfstp2Cao=";

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  excludedPackages = [ "docs/node-mixin" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Revision=unknown"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) node; };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Prometheus exporter for machine metrics";
    mainProgram = "node_exporter";
    homepage = "https://github.com/prometheus/node_exporter";
    changelog = "https://github.com/prometheus/node_exporter/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      fpletz
      globin
      Frostman
    ];
  };
})
