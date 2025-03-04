{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  darwin,
}:

buildGoModule rec {
  pname = "node_exporter";
  version = "1.9.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    hash = "sha256-mm4ZQjpIxaCbKIhZak0ZD4HVx3t+0m6YwjtIWak8RXc=";
  };

  vendorHash = "sha256-rItbct0UIWs9zulyoQF647RwLJkTsBTDJHLORCgVDo8=";

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      CoreFoundation
      IOKit
    ]
  );

  excludedPackages = [ "docs/node-mixin" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) node; };

  meta = with lib; {
    description = "Prometheus exporter for machine metrics";
    mainProgram = "node_exporter";
    homepage = "https://github.com/prometheus/node_exporter";
    changelog = "https://github.com/prometheus/node_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      benley
      fpletz
      globin
      Frostman
    ];
  };
}
