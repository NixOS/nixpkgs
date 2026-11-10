{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  testers,
  prometheus-nats-exporter,
}:

buildGoModule rec {
  pname = "prometheus-nats-exporter";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "prometheus-nats-exporter";
    rev = "v${version}";
    sha256 = "sha256-+5X4qWlVMMbsyHZgVeRaxpyOsyfSYXgdWv2cNu9PMRQ=";
  };

  vendorHash = "sha256-07cltrtsiSzIh9C5exVApbm8QtKqD2RK7w753e34pCE=";

  preCheck = ''
    # Fix `insecure algorithm SHA1-RSA` problem
    export GODEBUG=x509sha1=1;
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      prometheus-nats-exporter-version = testers.testVersion {
        package = prometheus-nats-exporter;
      };
    };
  };

  meta = {
    description = "Exporter for NATS metrics";
    homepage = "https://github.com/nats-io/prometheus-nats-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras ];
  };
}
