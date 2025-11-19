{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  testers,
  prometheus-pushgateway,
}:

buildGoModule rec {
  pname = "pushgateway";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "pushgateway";
    rev = "v${version}";
    sha256 = "sha256-Mc4yEd9CRfLZ4ZpcMnwQpoIXQpUerdxYD90FWRBzS20=";
  };

  vendorHash = "sha256-O/Vgn3WC0ZzRy5L/m0qR970joGtqQWWlmethoHAypgY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${version}"
    "-X github.com/prometheus/common/version.Branch=${version}"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=19700101-00:00:00"
  ];

  passthru.tests = {
    inherit (nixosTests.prometheus) pushgateway;
    version = testers.testVersion {
      package = prometheus-pushgateway;
    };
  };

  meta = with lib; {
    description = "Allows ephemeral and batch jobs to expose metrics to Prometheus";
    mainProgram = "pushgateway";
    homepage = "https://github.com/prometheus/pushgateway";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
