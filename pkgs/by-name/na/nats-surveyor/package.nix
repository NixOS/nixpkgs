{ lib, buildGoModule, fetchFromGitHub, }:
buildGoModule rec {
  pname = "nats-surveyor";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-surveyor";
    rev = "v${version}";
    hash = "sha256-7HJgSwsB7m1Y6U2+ZMQ0JHHdLge5v7wLjH5chlhB0F0=";
  };

  vendorHash = "sha256-NjwUiommvCy5arr1QCcDjqnxuLwN3fsj3C1O6hZL2jw=";

  meta = with lib; {
    homepage = "https://github.com/nats-io/nats-surveyor";
    description = "NATS Monitoring, Simplified.";
    longDescription = ''
      NATS surveyor polls the NATS server for Statz messages to
      generate data for Prometheus. This allows a single exporter
      to connect to any NATS server and get an entire picture of
      a NATS deployment without requiring extra monitoring
      components or sidecars.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
  };
}

