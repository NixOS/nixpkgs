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
  version = "1.8.2";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    hash = "sha256-b2uior67RcCCpUE+qx55G1eWiT2wWDVsnosSH9fd3/I=";
  };

  vendorHash = "sha256-sly8AJk+jNZG8ijTBF1Pd5AOOUJJxIG8jHwBUdlt8fM=";

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin (
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

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) node;
  };

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
